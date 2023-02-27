import { ApiPromise, WsProvider } from '@polkadot/api';
import type { AccountData, BlockNumber, Header } from '@polkadot/types/interfaces';
import { BN, formatBalance } from '@polkadot/util';
import Koa from 'koa';
import koaRoute from 'koa-route';
import './config'

const MAX_ELAPSED = 60000;
let currentBlockNumber: BlockNumber | undefined;
let currentTimestamp: Date = new Date();

let provider: WsProvider
let chainDecimals: number;
let chainUnit: string;

interface account {
  name: string;
  key: number;
  bal?: AccountData
}
let accounts: account[];

let port: string;
const metricName: string = "challenge_account_balance"

function initConfig() {
  try {
    if ( process.env.BASED == "true") {
      accounts = JSON.parse(Buffer.from(process.env.ACCOUNTS, 'base64').toString('utf-8')).accounts;
    } else {
      accounts = JSON.parse(process.env.ACCOUNTS).accounts;
    }
  } catch (e: any) {
    console.log(`${process.env.ACCOUNTS} not a valid JSON format`);
  }
  provider = new WsProvider(process.env.RPC_URL);
  port = process.env.PORT
}

function metrics(ctx: Koa.Context): void {
  let res: string = ''
  for (var account of accounts) {
    if (account.bal != undefined) {
      res += `${metricName}{name="${account.name}", key="${account.key}", unit="${chainUnit}"} ${formatBalance(account.bal.free, { withUnit: false })}\n`
    }

  }
  ctx.body = res.substring(0, res.length - 1);
  console.log(res)
}

function httpStatus(ctx: Koa.Context): void {
  ctx.body = { ok: true};
}

async function main(): Promise<void> {

  initConfig();

  const api = await ApiPromise.create({ provider });

  chainDecimals = api.registry.chainDecimals[0];
  chainUnit = api.registry.chainTokens[0];
  formatBalance.setDefaults({ unit: chainUnit, decimals: chainDecimals });

  for (let i = 0; i < accounts.length; i++) {
    const account = accounts[i];
    await api.query.system.account(account.key, (res: any) => {
      account.bal = res.data;
    });
  }

  const app = new Koa();
  app.use(koaRoute.get('/', httpStatus));
  app.use(koaRoute.get('/metrics', metrics));
  app.listen(port);

}

process.on('unhandledRejection', (error): void => {
  console.error(error);
  process.exit(1);
});

main().catch((error): void => {
  console.error(error);

  process.exit(1);
});