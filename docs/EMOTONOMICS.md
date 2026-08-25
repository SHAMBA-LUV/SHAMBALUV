# **SHAMBA LUV — Emotonomics Whitepaper**
**The Protocol for an Emotional Economy on-Chain**

**Live web publication:** https://luv.pythai.net/emotonomics.html  
**Home:** [luv.pythai.net](https://luv.pythai.net/) · [FAQ](https://luv.pythai.net/faq.html) · [the price of LUV](https://luv.pythai.net/view.html) · [the docs](https://luv.pythai.net/docs.html) · [for agents: llms.txt](https://luv.pythai.net/llms.txt)

---

## **PHASE 1 — LUV is Priceless**

We are entering an era where value is no longer determined solely by scarcity, price charts, or market capitalization.  
Value is increasingly defined by **connection**, **resonance**, and **participation**.

**[SHAMBA LUV](https://luv.pythai.net/)** is the world’s first **Emotonomic Protocol** — a blockchain-native system where **gestures, attention, and community impact** are the primary units of value.

In this system:

- Every transfer of **LUV** is not just a transaction — it is a **digital gesture**.
- The network is designed for **abundance**, not scarcity.
- The wealth of a community is measured by **engagement velocity**, not idle balances ([how it is measured](https://luv.pythai.net/sentiment.html)).

This is **[Emotonomics](https://luv.pythai.net/emotonomics.html)** — the science and system of creating, measuring, and amplifying value through **emotional transactions on-chain**. The story, card by card: [the LUV story](https://luv.pythai.net/luvstory.html).

---

## **The Emotonomics Model**

### **Premise**
Traditional economics relies on **limited supply** to generate value.  
**Emotonomics** generates value through **unlimited emotional resonance**.

Value flows through three primary vectors:
1. **Attention** – Moments when someone notices and engages with a gesture.  
2. **Gestures** – Digital acts of giving, acknowledgment, or support.  
3. **Impact** – The measurable positive effect that gesture has on individuals and the network.

### **Attention as Value — the lineage**
Emotonomics does not invent the claim that attention is value; it implements it. The lineage runs
for half a century:

- **Herbert A. Simon (1971)** first stated the scarcity: "a wealth of information creates a poverty of
  attention" — attention, not information, is the resource that must be allocated efficiently.
- **Michael H. Goldhaber (1997)**, *The Attention Economy and the Net*, argued that on a network attention
  is the **native currency** — scarce, non-duplicable, and flowing from person to person like money.
- **Georg Franck (1998; 1999)**, *Ökonomie der Aufmerksamkeit* / *The Economy of Attention*, formalised
  attention as **income and capital**: it is earned, accumulated, invested and yields a return ("mental
  capitalism").
- **Thomas H. Davenport & John C. Beck (2001)**, *The Attention Economy: Understanding the New Currency of
  Business*, brought the currency framing into management economics.
- **Jonathan Beller (2006)**, *The Cinematic Mode of Production*, proposed an explicit **attention theory
  of value**: looking is labour, and attention produces value the way work does.
- **Richard A. Lanham (2006)**, *The Economics of Attention*, showed that in an information-rich world
  **style is substance** because it is style that allocates attention.
- **Tim Wu (2016)**, *The Attention Merchants*, documented the industry that **harvests** attention and
  resells it — the extractive model Emotonomics inverts.
- **Yves Citton (2017)**, *The Ecology of Attention*, reframed attention from a resource to be mined
  into an **ecology to be cultivated** — attention given is also attention grown.

Every one of these economists treats attention as scarce, transferable and productive — i.e. as value.
What they lacked was a **ledger**. Emotonomics gives attention a public, on-chain unit of account
(the gesture), a settlement layer (the [LUV contract](https://luv.pythai.net/faq.html#contracts)) and a
price (the [pair](https://luv.pythai.net/luveth.html)) — so attention is no longer harvested *from*
participants by merchants (Wu) but **paid to** participants by each other (Citton). Attention Credits,
Gesture Tokens and Impact Points are the accounting entries of that literature.

---

### **Units of Emotonomic Value**
- **Gesture Token (GT)**: A LUV transfer that carries emotional meaning. **1,000,000 LUV is the standard gesture** — see [the wei of LUV](https://luv.pythai.net/wei.html) for the arithmetic.  
- **Attention Credits (AC)**: Quantified moments of audience engagement (views, likes, comments, shares).  
- **Impact Points (IP)**: Contributions to community well-being, visibility, or cohesion.

---

### **Value Creation Cycle**
1. **Seed** – A user sends LUV to someone.  
2. **Amplify** – That gesture is shared, reciprocated, or discussed.  
3. **Resonate** – The network experiences an emotional uplift.  
4. **Harvest** – Participants gain social capital and cultural presence.  
5. **Compound** – Each subsequent gesture builds on prior ones, expanding influence.

How the field turns into working code — the pulse, the oracle, the rails — is derived in [the LUV engine](https://luv.pythai.net/engine.html).

---

## **Technical Overview**

### **Blockchain Infrastructure**
- **Network**: Ethereum-first, multichain-ready — the LUV contract lives at the **same
  deterministic address on every chain** ([the ledger — verified contracts](https://luv.pythai.net/faq.html#contracts))  
- **Token Standard**: ERC-20 (**LUV**)  
- **Total Supply**: **111 Quadrillion** — the repunit of ones
  (111,111,111,111,111,111.111111111111111111 LUV), **fixed at genesis**, no mint function  
- **Circulating Supply**: **100 Quadrillion** — the public liquidity pool, **paired with ETH**
  ([LUV / ETH — the pair](https://luv.pythai.net/luveth.html) · [the liquidity is locked](https://luv.pythai.net/liqlock.html))  
- **Startup Allocation**: the remaining **11.1 Quadrillion**, split evenly four ways —
  **Founders 2.777Q** (liquid) · **Treasury 2.777Q** (liquid; funds the gesture campaign:
  a 1-Quadrillion pool = 1,000 free airdrops of 1 Trillion) · **Marketing 2.777Q** (locked in
  the [LUVlocker](https://luv.pythai.net/faq.html)) · **Community 2.778Q** (locked — the split's rounding remainder is
  deliberately given to the community: sharing is caring, [down to the last wei](https://luv.pythai.net/wei.html))  
- **Transaction Fee Structure** (5% on market trades through the pair, split **3:1:1**;
  wallet-to-wallet gestures carry **no fee** — 1 LUV === 1 LUV; details in the [FAQ](https://luv.pythai.net/faq.html)):  
  - 3% Holder Reflections – Rewards for holding LUV.  
  - 1% Auto-Liquidity – Sustains market presence.  
  - 1% Marketing Wallet – Funds viral campaigns and community events.

The fee model is not an investment mechanic — it is a **redistribution of emotional influence** to active network participants.

---

### **Proof of Gesture (PoG)**
Every LUV transfer is logged with:
- Sender Address  
- Receiver Address  
- Timestamp  
- Optional Context Tag (event, campaign, purpose)

This creates a **public ledger of gestures**, allowing anyone to trace the spread of LUV through the ecosystem. Batched gestures ride [the LUVbus](https://luv.pythai.net/luvbus.html).

---

### **[Incentive Distributor](https://luv.pythai.net/)**
The Incentive Distributor is an off-chain + on-chain hybrid system that:
- Rewards users for performing **viral actions** (tweeting, sharing, joining events).  
- Issues **bonus LUV** for high-value gestures during campaigns.  
- Integrates with platforms like Twitter, Instagram, Telegram for **gesture verification**.

Live today as [the LUVdrip — a million a day, for logging in](https://luv.pythai.net/faq.html#luvdrip); the open items are on [the list](https://luv.pythai.net/faq.html#todo-distributor).

---

### **Measurement Systems**
- **Gesture Velocity Index (GVI)**: Measures how fast LUV circulates.  
- **Community Resonance Depth (CRD)**: Tracks how far and deep gesture chains spread.  
- **Emotional ROI (eROI)**: Compares gestures given to gestures received, measuring reciprocity health.

Community actions are the measure of community sentiment — the full indicator set, and its derivative **sentiment.shift**, is specified in [the measurement paper](https://luv.pythai.net/sentiment.html).

---

## **PHASE 3 — LUV has a Price**

LUV began **priceless** — an abundance with no denominator. It transitioned to **having a price** the moment
**Ethereum was added as value**: the [LUV / ETH pair](https://luv.pythai.net/luveth.html) was seeded on Uniswap V2
with LUV on one side and ETH on the other, and a price came into existence. Nothing was declared; the pair
*created* the price, Uniswap *expresses* it, and [the oracle](https://luv.pythai.net/view.html) *measures* it.

The price exists **both ways** ([LUV.html — the price, both ways](https://luv.pythai.net/LUV.html)):
- **LUV / ETH** — how much ETH one LUV is worth (the seed: exactly **10 wei per LUV**).  
- **ETH / LUV** — how much LUV one ETH is worth (the seed: **10^17 LUV per ETH**).

Because both directions carry value, LUV is no longer only a gesture — it is a **medium of exchange**. Anyone in
the world can now **share LUV** and **transact using LUV**, in either direction, against the most liquid
programmable asset on earth. The price is the bridge between the emotional economy and the monetary one.

- [LIVE VIEW — the LUV price, live on Uniswap](https://luv.pythai.net/view.html)  
- [THE LUVchart — drawn from the pair](https://luv.pythai.net/luvchart.html)  
- [the Bitcoin rainbow, in-house](https://luv.pythai.net/rainbow.html)  
- machine-readable: [market.json](https://luv.pythai.net/market.json) · [luv.live.json](https://luv.pythai.net/luv.live.json)  
- adding LUV to your wallet at the right price: [FAQ — MetaMask price](https://luv.pythai.net/faq.html#metamask-price)

### **LUV Bridges — value created from connections**
Every gesture is a **connection** between two participants. Every connection is a **bridge** over which LUV can
flow — and, now that LUV is priced, over which *value* can flow. The pair is the first bridge (LUV ⇄ ETH); every
gesture that follows extends the bridge network by one span. LUV bridges are not built by a foundation or a
market-maker: they are **created from connections**, by the participants themselves, one gesture at a time.

### **Metcalfe's Law**
Metcalfe's law states that the value of a network grows with the **square of the number of connected
participants**: for *n* participants there are *n(n−1)/2* possible connections, so

> **V ∝ n²**

(Metcalfe 1980; Metcalfe 2013). The law has empirical support — Zhang, Liu & Xu (2015) validated the n²
fit against a decade of Facebook and Tencent revenue — and a serious critic: Odlyzko & Tilly (2005) argue
value grows as *n log n* because not every connection is equally valuable. Emotonomics accepts the
critique and answers it with measurement: gestures weight the edges, so the [Gesture Velocity
Index](https://luv.pythai.net/sentiment.html) reports the *realised* network, not the possible one.
Emotonomics is Metcalfe's law applied to gestures. Each participant who holds LUV is a node; each gesture is an
edge; each edge is a bridge over which priced value can move. The three vectors of the model map directly onto it:

| Metcalfe | Emotonomics | measured at |
|---|---|---|
| nodes *n* | holders — the community | [holders table](https://luv.pythai.net/view.html) |
| edges *n(n−1)/2* | gestures — the bridges | [Gesture Velocity Index](https://luv.pythai.net/sentiment.html) |
| value *V ∝ n²* | the price × the network | [the price of LUV](https://luv.pythai.net/LUV.html) |

Two consequences follow. First, **abundance is not dilution**: adding a participant adds *n* new potential
bridges, so the network's value grows faster than its supply is shared. Second, **sharing IS the value
creation**: the 3% reflection pays every existing node when a new one connects, so the Metcalfe gain is
distributed to the holders who form the network, not captured by an issuer. LUV is the asset whose price rises
with the square of the people who share it — which is why Phase 4 is simply **SHARE the LUV**.

### **Identity, the OVERLORD, and the Hierarchy of Participation**
A gesture is only meaningful if the sender is real. [BANKON](https://bankon.pythai.net/) — sovereign identity
infrastructure — requires **identity verification from signature**: a participant proves who they are by signing,
never by handing over custody. That signed identity is what LUV's login, wallet provisioning, and every earn action
rest on.

Signature-verified identity led to the **OVERLORD** — `bankon.eth`, the deployer whose signature confirms the
contracts on every chain — and from the OVERLORD descends the **hierarchy of participant interactions**:
`free → sovereign → agent → member → model → overseer → overlord`. A `subname.bankon.eth` holder is always a
**sovereign** participant; the higher tiers are **earned from actions**, never assigned.

Rewards flow down that hierarchy from verifiable actions — logging in, gesturing, sharing, holding — and are paid
in **LUV and other assets** (ERC-20s, iNFTs, and the assets of the [DeltaVerse](https://deltaverse.pythai.net/)),
with agents on [AgenticPlace](https://agenticplace.pythai.net/) participating under the same rule: **consensus before
custody, signature before reward.** The live rails: [the LUVdrip](https://luv.pythai.net/faq.html#luvdrip) and
[earning more LUV](https://luv.pythai.net/faq.html).

---

## **Why Emotonomics Works**
- **Abundance over Scarcity** – In traditional economics, abundance dilutes value. In Emotonomics, abundance **increases network effects**.  
- **Social Proof Loops** – Public gestures trigger replication through mimicry and cultural signaling.  
- **Positive Association Memory** – Repeated positive gestures attach emotional weight to LUV over time.  
- **Resistance to Price Volatility** – Value exists in emotional transactions, not [market fluctuations](https://luv.pythai.net/view.html).

---

## **Use Cases**
- **Community Rewards** – Acknowledge members in DAOs, clubs, and groups.  
- **Event Amplification** – Coordinate LUV Bomb campaigns to flood a cause or moment with attention.  
- **Brand Engagement** – Businesses reward genuine customer engagement with LUV gestures.  
- **Social Defense** – Deploy LUV Shields to protect communities from FUD and negativity.  
- **Agent Economies** – SHAMBA LUV is robot positive: *in the same way that LUV is LUV, intelligence is intelligence.*
  Autonomous agents registered on [AgenticPlace](https://agenticplace.pythai.net/) — the ERC-8004 agent registry —
  can hold, gesture, and be acknowledged in LUV; the agents' guide is [llms.txt](https://luv.pythai.net/llms.txt).

---

## **Vision**
SHAMBA LUV will evolve into the **universal gesture protocol** for Web3 and beyond.  
It will power:
- Social platforms  
- Metaverse interactions — the [DeltaVerse](https://deltaverse.pythai.net/) is emerging: a fluid dynamic between participants and AI, where LUV is the gesture  
- Digital art communities  
- DAO governance recognition systems  
- Agent-to-agent acknowledgment on [AgenticPlace](https://agenticplace.pythai.net/)  

We believe the future of value isn’t in how much you can hoard, but **how far your gestures can reach**.

Identity at 10^18 — one exabyte, one ether, one LUV — is argued in [the identity paper](https://luv.pythai.net/exabyte.html).

---

## **Conclusion**
Emotonomics is a **paradigm shift** — a redefinition of value where **emotions, not scarcity, fuel the economy**.  
SHAMBA LUV is the **first implementation** of this model, designed to **weaponize abundance** for cultural, social, and emotional impact.

In the LUV economy:
- **Attention is capital**  
- **Gestures are currency**  
- **Impact is profit**

---

### **References**
- Beller, J. (2006). *The Cinematic Mode of Production: Attention Economy and the Society of the Spectacle*. Hanover, NH: Dartmouth College Press.
- Citton, Y. (2017). *The Ecology of Attention* (B. Norman, Trans.). Cambridge: Polity.
- Davenport, T. H., & Beck, J. C. (2001). *The Attention Economy: Understanding the New Currency of Business*. Boston: Harvard Business School Press.
- Franck, G. (1998). *Ökonomie der Aufmerksamkeit: Ein Entwurf*. Munich: Carl Hanser.
- Franck, G. (1999). The economy of attention. *Telepolis*, 7 December 1999.
- Goldhaber, M. H. (1997). The attention economy and the Net. *First Monday*, 2(4).
- Lanham, R. A. (2006). *The Economics of Attention: Style and Substance in the Age of Information*. Chicago: University of Chicago Press.
- Metcalfe, R. (1980). Metcalfe's law (as first presented in 3Com sales material; named by G. Gilder, 1993).
- Metcalfe, B. (2013). Metcalfe's law after 40 years of Ethernet. *IEEE Computer*, 46(12), 26–31.
- Odlyzko, A., & Tilly, B. (2005). *A refutation of Metcalfe's Law and a better estimate for the value of networks and network interconnections*. University of Minnesota, Digital Technology Center.
- Simon, H. A. (1971). Designing organizations for an information-rich world. In M. Greenberger (Ed.), *Computers, Communications, and the Public Interest* (pp. 37–72). Baltimore: Johns Hopkins Press.
- Wu, T. (2016). *The Attention Merchants: The Epic Scramble to Get Inside Our Heads*. New York: Knopf.
- Zhang, X.-Z., Liu, J.-J., & Xu, Z.-W. (2015). Tencent and Facebook data validate Metcalfe's law. *Journal of Computer Science and Technology*, 30(2), 246–251.
- SHAMBA LUV papers: [emotonomics](https://luv.pythai.net/emotonomics.html) · [the engine](https://luv.pythai.net/engine.html) · [sentiment](https://luv.pythai.net/sentiment.html) · [wei](https://luv.pythai.net/wei.html) · [exabyte](https://luv.pythai.net/exabyte.html)

---

### **Where the LUV lives**
| component | link |
|---|---|
| home | [luv.pythai.net](https://luv.pythai.net/) |
| FAQ | [faq.html](https://luv.pythai.net/faq.html) · [contracts](https://luv.pythai.net/faq.html#contracts) · [roadmap](https://luv.pythai.net/faq.html#roadmap) · [LUVdrip](https://luv.pythai.net/faq.html#luvdrip) |
| price | [view.html](https://luv.pythai.net/view.html) · [LUV.html](https://luv.pythai.net/LUV.html) · [luvchart.html](https://luv.pythai.net/luvchart.html) · [luveth.html](https://luv.pythai.net/luveth.html) · [market.json](https://luv.pythai.net/market.json) |
| papers | [emotonomics](https://luv.pythai.net/emotonomics.html) · [engine](https://luv.pythai.net/engine.html) · [sentiment](https://luv.pythai.net/sentiment.html) · [wei](https://luv.pythai.net/wei.html) · [exabyte](https://luv.pythai.net/exabyte.html) |
| rails | [LUVbus](https://luv.pythai.net/luvbus.html) · [LIQ LOCKER](https://luv.pythai.net/liqlock.html) · [the rainbow](https://luv.pythai.net/rainbow.html) |
| docs | [docs.html](https://luv.pythai.net/docs.html) · [the LUV story](https://luv.pythai.net/luvstory.html) · [llms.txt](https://luv.pythai.net/llms.txt) |
| identity | [BANKON](https://bankon.pythai.net/) — sovereign identity, verified by signature |
| agents | [AgenticPlace](https://agenticplace.pythai.net/) — the ERC-8004 agent registry |
| emerging | [DeltaVerse](https://deltaverse.pythai.net/) |

---
