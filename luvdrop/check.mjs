#!/usr/bin/env node
// check.mjs — the pioneers' LUVdrop, checked on both chains: 1 LUV on Polygon == 1 LUV on Ethereum.
//
//   node luvdrop/check.mjs                      read both chains now and print every seat
//   node luvdrop/check.mjs --json OUT.json      also write the record
//
// For every holder of the Polygon original (0x1035…456e) in polygon-holders-<block>.json, it re-reads the
// Polygon balance at a pinned recent block, and reads the LUV balance of that seat's Ethereum recipient
// (delivery-map.json: a smart account delivers to its admin EOA; an EOA to itself) at a pinned Ethereum
// block. Every amount is an integer of 10^-18 (the SCIEN·TIFIC standard of accuracy, docs/ACCURACY.md).
//
//   ✅ verified  the recipient holds at least the 1:1 equivalent of its seats on Ethereum
//   🟠 warning   not delivered yet, partly delivered, above the 1T LUV cohort ceiling, or no recipient
//   ❌ fail      the Polygon balance no longer equals the ledger's (the list would pay a wrong amount),
//                or a balance could not be read
//
// It also adds the listed balances and compares them with totalSupply(): if they fall short, holders
// exist that the list does not name. Node 18+ (global fetch); no dependencies; reads only, sends nothing.
import { readFileSync, readdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const LEDGER = readdirSync(HERE).filter((f) => /^polygon-holders-\d+\.json$/.test(f)).sort().at(-1);
const led = JSON.parse(readFileSync(join(HERE, LEDGER), "utf8"));
const dmap = JSON.parse(readFileSync(join(HERE, "delivery-map.json"), "utf8")).map;
const POLY = { token: led.token, rpc: ["https://polygon-bor-rpc.publicnode.com", "https://polygon.drpc.org"] };
const ETH = { token: "0x2711111111683B8708cb9a48cBf36a51315F8254", rpc: ["https://ethereum-rpc.publicnode.com", "https://cloudflare-eth.com"] };
const SCALE = 10n ** 18n, CEIL = 1000000000000n * SCALE;
const fmt = (w) => `${w / SCALE}.${(w % SCALE).toString().padStart(18, "0")}`;
const tty = process.stdout.isTTY;
const paint = (code, s) => (tty ? `\x1b[${code}m${s}\x1b[0m` : s);
const MARK = { verified: paint("38;2;14;203;129", "✅ verified"), warn: paint("38;2;247;147;26", "🟠 warning "), fail: paint("38;2;246;70;93", "❌ fail    ") };

async function batch(net, calls) {
  let last;
  for (const url of net.rpc) {
    try {
      const r = await fetch(url, { method: "POST", headers: { "content-type": "application/json" }, signal: AbortSignal.timeout(30000),
        body: JSON.stringify(calls.map((c, i) => ({ jsonrpc: "2.0", id: i, ...c }))) });
      const j = await r.json();
      if (!Array.isArray(j)) throw new Error("not a batch answer");
      const by = new Map(j.map((x) => [x.id, x]));
      return { host: new URL(url).host, results: calls.map((_, i) => { const x = by.get(i); if (!x || x.error || typeof x.result !== "string") throw new Error(x?.error?.message || "no result"); return x.result; }) };
    } catch (e) { last = e; }
  }
  throw new Error(`no endpoint answered: ${last?.message}`);
}
const balanceCall = (token, a, block) => ({ method: "eth_call", params: [{ to: token, data: "0x70a08231" + a.slice(2).padStart(64, "0") }, block] });
async function pinned(net) { const { results: [h] } = await batch(net, [{ method: "eth_blockNumber", params: [] }]); return "0x" + (BigInt(h) - 5n).toString(16); }

const pBlock = await pinned(POLY), eBlock = await pinned(ETH);
const addrs = led.rows.map((r) => r.address);
const pol = await batch(POLY, [...addrs.map((a) => balanceCall(POLY.token, a, pBlock)), { method: "eth_call", params: [{ to: POLY.token, data: "0x18160ddd" }, pBlock] }]);
const supply = BigInt(pol.results.at(-1));
const seats = led.rows.map((r, i) => {
  const now = BigInt(pol.results[i]), ledger = BigInt(r.balance_wei);
  return { polygon: r.address, contract: r.is_contract, ledger, now, inCohort: ledger <= CEIL, to: dmap[r.address] || (r.is_contract ? null : r.address) };
});
const recips = [...new Set(seats.filter((s) => s.inCohort && s.to).map((s) => s.to))];
const eth = await batch(ETH, recips.map((a) => balanceCall(ETH.token, a, eBlock)));
const have = new Map(recips.map((a, i) => [a, BigInt(eth.results[i])]));
const owed = new Map(); for (const s of seats) if (s.inCohort && s.to) owed.set(s.to, (owed.get(s.to) || 0n) + s.ledger);

for (const s of seats) {
  if (s.now !== s.ledger) { s.status = "fail"; s.note = `the ledger says ${fmt(s.ledger)}, Polygon now holds ${fmt(s.now)}`; continue; }
  if (!s.inCohort) { s.status = "warn"; s.note = "above the 1T LUV cohort ceiling: outside the drop unless decided otherwise"; continue; }
  if (!s.to) { s.status = "warn"; s.note = "a contract with no Ethereum recipient yet"; continue; }
  const h = have.get(s.to), need = owed.get(s.to);
  if (h >= need) { s.status = "verified"; s.note = `${s.to} holds ${fmt(h)} LUV on Ethereum (owed ${fmt(need)})`; }
  else if (h === 0n) { s.status = "warn"; s.note = `${s.to} holds 0 LUV on Ethereum: not delivered yet`; }
  else { s.status = "warn"; s.note = `${s.to} holds ${fmt(h)} of ${fmt(need)} LUV owed on Ethereum`; }
}
const listed = seats.reduce((t, s) => t + s.now, 0n), gap = supply - listed;
console.log(`Polygon block ${Number(BigInt(pBlock))} (${pol.host}) · Ethereum block ${Number(BigInt(eBlock))} (${eth.host})`);
for (const s of seats) console.log(`${MARK[s.status]}  ${s.polygon}  ${fmt(s.ledger).padStart(42)} LUV  ${s.note}`);
const n = (k) => seats.filter((s) => s.status === k).length;
console.log(`\n${MARK.verified} ${n("verified")}   ${MARK.warn} ${n("warn")}   ${MARK.fail} ${n("fail")}   (${seats.filter((s) => s.inCohort).length} cohort seats, ${recips.length} Ethereum recipients)`);
console.log(gap === 0n ? `${MARK.verified} supply: the listed balances add up to totalSupply() exactly; no holder is missing`
  : `${MARK.warn} supply: ${fmt(gap)} LUV of ${fmt(supply)} is held by addresses the list does not name`);
const i = process.argv.indexOf("--json");
if (i > 0 && process.argv[i + 1]) writeFileSync(process.argv[i + 1], JSON.stringify({ polygonBlock: Number(BigInt(pBlock)), ethereumBlock: Number(BigInt(eBlock)),
  supply_wei: supply.toString(), unaccounted_wei: gap.toString(), seats: seats.map((s) => ({ ...s, ledger: s.ledger.toString(), now: s.now.toString() })) }, null, 1));
process.exitCode = n("fail") ? 1 : 0;
