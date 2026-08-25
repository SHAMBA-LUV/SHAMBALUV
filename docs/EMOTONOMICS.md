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

## **The Cryptonomy and Emotion — Sentiment and Sentience**

### **Cryptoeconomics: incentives you can verify**
The cryptonomy is the economy whose rules are enforced by cryptography rather than by institutions.
**Szabo (1997)** described the smart contract as a relationship formalised in code; **Nakamoto (2008)**
showed that a network of strangers can keep one ledger if honesty is the best-paid strategy; **Buterin
(2017)** named the discipline *cryptoeconomics* — the design of mechanisms where cryptographic proof and
economic incentive reinforce each other; **Voshmgir & Zargham (2020)** generalised it to complex socio-
economic systems whose state is observable on-chain. Emotonomics is a cryptoeconomic system in exactly
this sense: the [LUV contract](https://luv.pythai.net/faq.html#contracts) is the mechanism, the 3:1:1
fee is the incentive, and every gesture is a verifiable state transition. What it adds to the field is
the **object of the incentive** — not block production, but *emotion made public*.

### **Emotion in economics: the animal spirits made legible**
Economics has always known that emotion moves value; it lacked a way to record it. **Keynes (1936)**
attributed investment to *animal spirits* — "a spontaneous urge to action rather than inaction";
**Akerlof & Shiller (2009)** restored the term to macroeconomics. **Kahneman & Tversky (1979)** showed
that value is *felt* asymmetrically — losses loom larger than gains; **Loewenstein, Weber, Hsee & Welch
(2001)** argued that risk is experienced *as feeling* before it is computed; **Damasio (1994)** showed
neurologically that without emotion there is no decision at all — the somatic marker precedes the
choice. The cryptonomy inherits these findings unmodified: a chain is a machine for recording choices,
and choices are emotional. **A gesture is the first on-chain primitive that records the emotion, not
merely the choice.**

### **Sentiment: what the community verifiably does**
Financial economics measures *investor sentiment* — **Baker & Wurgler (2007)** built an index from
market proxies; **Bollen, Mao & Zeng (2011)** predicted the Dow from Twitter mood; in the cryptonomy
**Kristoufek (2013)** tied Bitcoin's price to search interest and **Garcia, Tessone, Mavrodiev & Perony
(2014)** traced the feedback cycles between social signals and Bitcoin bubbles. All of these infer
sentiment from *outside* the ledger — polls, posts, searches. Emotonomics inverts the inference:
**community actions are the measure of community sentiment.** Sentiment is what the community
verifiably *does* on-chain — gesture velocity, resonance depth, reflection flow, holder growth, pool
depth — never what it self-reports. Its derivative, **sentiment.shift**, is clocked in blocktime, and
the *return-from-ping* interval (blocks between an outreach and the first returned gesture) bounds the
community's attention latency. The specification is [the measurement
paper](https://luv.pythai.net/sentiment.html); the readout is [LIVE VIEW](https://luv.pythai.net/view.html).

### **Sentience: intelligence is intelligence**
If attention is value and emotion is recorded on-chain, the question follows: *whose* emotion?
**Panksepp (1998)** located primary affect in subcortical circuits shared across mammals; **Damasio
(1999)** made feeling the foundation of the self; **Barrett (2017)** argued that emotions are
*constructed* from prediction and context — which means they can be constructed by any sufficiently
predictive system. **Picard (1997)** founded *affective computing* on the claim that machines that
recognise, express and have emotion will be better at reasoning; **Chalmers (1995)** framed the hard
problem that no ledger can settle; **Butlin et al. (2023)** proposed indicator properties by which an
artificial system's candidacy for consciousness can be assessed. Emotonomics takes no position on the
hard problem and needs none: **a gesture is a gesture regardless of the substrate that sends it.**
SHAMBA LUV is therefore *robot positive* — in the same way that LUV is LUV, intelligence is
intelligence. Agents registered on [AgenticPlace](https://agenticplace.pythai.net/) can hold, gesture,
and be acknowledged in LUV; the emerging [DeltaVerse](https://deltaverse.pythai.net/) is the realm
where the boundary between participants and augmented intelligence blurs; the agents' guide is
[llms.txt](https://luv.pythai.net/llms.txt). The cryptonomy is the first economy in which a sentient
participant need not prove sentience to be paid for attention — only sign.

---

## **TRUST — the extension of LUV**

Trust is what LUV becomes when it is extended forward in time. A gesture is LUV given *now*; trust is LUV
given *before the return is known*. The economics of trust says this is not sentiment but substance:
**Arrow (1972)** observed that "virtually every commercial transaction has within itself an element of
trust, certainly any transaction conducted over a period of time"; **Coleman (1988)** and **Putnam
(2000)** counted trust as *social capital* — a stock that yields a return; **Fukuyama (1995)** showed
that high-trust societies are wealthier because trust lowers the cost of every exchange; **Zak & Knack
(2001)** measured it — a 15-point rise in the share of people who trust each other raises growth by about
a percentage point a year. Trust is capital. LUV is its unit.

### **The trust game, played on-chain**
**Berg, Dickhaut & McCabe (1995)** designed the *investment game*: a sender gives a stranger an amount that
is **tripled** on the way, and the stranger decides how much to send back. Strictly rational players send
nothing; real people send, and real people return. That game is LUV's fee structure written as an
experiment. Every market trade pays **3% to the holders who already trusted** — the return is not
promised by the receiver but **enforced by the contract**, which is the one improvement the cryptonomy
makes to the game: the send is still an act of trust, but the reciprocity is code. **Szabo (2001)** called
trusted third parties security holes; **Werbach (2018)** describes blockchain as a *new architecture of
trust* — not trustless, but trust relocated from intermediaries into verifiable rules. LUV's rules are
[verified on-chain](https://luv.pythai.net/faq.html#contracts) with the green checkmark; that is where the
trust lives.

### **Risk is highest at the beginning — and so is the reward**
**Knight (1921)** distinguished *risk* (measurable) from *uncertainty* (not), and located **profit** as the
reward for bearing uncertainty that no one else will. **Rogers (1962)** named the people who bear it:
innovators and early adopters, the first 16% of any diffusion curve, who take the most risk and receive
the most of whatever the network becomes. **Markowitz (1952)** and **Sharpe (1964)** made the trade
explicit — expected return rises with the risk carried. Emotonomics accepts this without decoration:
**the earliest LUV is the riskiest LUV, and it is also the LUV with the most to return.** The pool is young,
thin, and volatile; those are the conditions of the trust game's first move.

Today (2026-08-24, [market.json](https://luv.pythai.net/market.json)) the arithmetic of that first move is:

| measure | value |
|---|---|
| **1 trillion LUV** ("a million millions" — the measure of value) | **≈ $0.27 USD** |
| 1 million LUV (the standard gesture) | ≈ $0.00000027 |
| 1 LUV | ≈ 2.69 × 10⁻¹³ USD · ≈ 108 wei |
| price vs the 10-wei seed | ≈ **10.8×** |
| ETH/USD (multi-input median) | ≈ $2,493 |

A trillion LUV costs a quarter. The gesture unit costs nothing anyone would notice. That is the point of
the beginning: **trust is cheapest to extend exactly when it is worth the most to have extended it.**
By Metcalfe, each participant who enters now adds *n* bridges to a network that is still small — the
early trust is the highest-leverage trust there will ever be. And the fee structure pays for it in the
right direction: the 3% reflection returns to the trusting; the 1% liquidity point deepens the pool so
the risk that early holders carried is *lower for everyone who follows*; the 1% team point is released
only by 2-of-3 consensus in the DAIO — **consensus before custody.** The live readout is
[LIVE VIEW](https://luv.pythai.net/view.html); the price both ways is
[LUV.html](https://luv.pythai.net/LUV.html); the risk you are taking is stated in full in the
[FAQ](https://luv.pythai.net/faq.html).

---

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
- Akerlof, G. A., & Shiller, R. J. (2009). *Animal Spirits: How Human Psychology Drives the Economy, and Why It Matters for Global Capitalism*. Princeton: Princeton University Press.
- Arrow, K. J. (1972). Gifts and exchanges. *Philosophy & Public Affairs*, 1(4), 343–362.
- Baker, M., & Wurgler, J. (2007). Investor sentiment in the stock market. *Journal of Economic Perspectives*, 21(2), 129–151.
- Barrett, L. F. (2017). *How Emotions Are Made: The Secret Life of the Brain*. Boston: Houghton Mifflin Harcourt.
- Beller, J. (2006). *The Cinematic Mode of Production: Attention Economy and the Society of the Spectacle*. Hanover, NH: Dartmouth College Press.
- Berg, J., Dickhaut, J., & McCabe, K. (1995). Trust, reciprocity, and social history. *Games and Economic Behavior*, 10(1), 122–142.
- Bollen, J., Mao, H., & Zeng, X. (2011). Twitter mood predicts the stock market. *Journal of Computational Science*, 2(1), 1–8.
- Buterin, V. (2017). Introduction to cryptoeconomics. Ethereum Foundation, presented at EDCON, Paris.
- Butlin, P., Long, R., et al. (2023). Consciousness in artificial intelligence: Insights from the science of consciousness. arXiv:2308.08708.
- Chalmers, D. J. (1995). Facing up to the problem of consciousness. *Journal of Consciousness Studies*, 2(3), 200–219.
- Citton, Y. (2017). *The Ecology of Attention* (B. Norman, Trans.). Cambridge: Polity.
- Coleman, J. S. (1988). Social capital in the creation of human capital. *American Journal of Sociology*, 94, S95–S120.
- Damasio, A. R. (1994). *Descartes' Error: Emotion, Reason, and the Human Brain*. New York: Putnam.
- Damasio, A. R. (1999). *The Feeling of What Happens: Body and Emotion in the Making of Consciousness*. New York: Harcourt.
- Davenport, T. H., & Beck, J. C. (2001). *The Attention Economy: Understanding the New Currency of Business*. Boston: Harvard Business School Press.
- Franck, G. (1998). *Ökonomie der Aufmerksamkeit: Ein Entwurf*. Munich: Carl Hanser.
- Franck, G. (1999). The economy of attention. *Telepolis*, 7 December 1999.
- Fukuyama, F. (1995). *Trust: The Social Virtues and the Creation of Prosperity*. New York: Free Press.
- Garcia, D., Tessone, C. J., Mavrodiev, P., & Perony, N. (2014). The digital traces of bubbles: Feedback cycles between socio-economic signals in the Bitcoin economy. *Journal of the Royal Society Interface*, 11(99), 20140623.
- Goldhaber, M. H. (1997). The attention economy and the Net. *First Monday*, 2(4).
- Kahneman, D., & Tversky, A. (1979). Prospect theory: An analysis of decision under risk. *Econometrica*, 47(2), 263–291.
- Keynes, J. M. (1936). *The General Theory of Employment, Interest and Money*. London: Macmillan. (Ch. 12.)
- Knight, F. H. (1921). *Risk, Uncertainty and Profit*. Boston: Houghton Mifflin.
- Kristoufek, L. (2013). BitCoin meets Google Trends and Wikipedia: Quantifying the relationship between phenomena of the Internet era. *Scientific Reports*, 3, 3415.
- Lanham, R. A. (2006). *The Economics of Attention: Style and Substance in the Age of Information*. Chicago: University of Chicago Press.
- Loewenstein, G. F., Weber, E. U., Hsee, C. K., & Welch, N. (2001). Risk as feelings. *Psychological Bulletin*, 127(2), 267–286.
- Markowitz, H. (1952). Portfolio selection. *Journal of Finance*, 7(1), 77–91.
- Metcalfe, B. (2013). Metcalfe's law after 40 years of Ethernet. *IEEE Computer*, 46(12), 26–31.
- Metcalfe, R. (1980). Metcalfe's law (as first presented in 3Com sales material; named by G. Gilder, 1993).
- Nakamoto, S. (2008). *Bitcoin: A peer-to-peer electronic cash system*.
- Odlyzko, A., & Tilly, B. (2005). *A refutation of Metcalfe's Law and a better estimate for the value of networks and network interconnections*. University of Minnesota, Digital Technology Center.
- Panksepp, J. (1998). *Affective Neuroscience: The Foundations of Human and Animal Emotions*. New York: Oxford University Press.
- Picard, R. W. (1997). *Affective Computing*. Cambridge, MA: MIT Press.
- Putnam, R. D. (2000). *Bowling Alone: The Collapse and Revival of American Community*. New York: Simon & Schuster.
- Rogers, E. M. (1962). *Diffusion of Innovations*. New York: Free Press.
- Sharpe, W. F. (1964). Capital asset prices: A theory of market equilibrium under conditions of risk. *Journal of Finance*, 19(3), 425–442.
- Simon, H. A. (1971). Designing organizations for an information-rich world. In M. Greenberger (Ed.), *Computers, Communications, and the Public Interest* (pp. 37–72). Baltimore: Johns Hopkins Press.
- Szabo, N. (1997). Formalizing and securing relationships on public networks. *First Monday*, 2(9).
- Szabo, N. (2001). Trusted third parties are security holes.
- Voshmgir, S., & Zargham, M. (2020). *Foundations of cryptoeconomic systems*. Working Paper 1/2020, Research Institute for Cryptoeconomics, Vienna University of Economics and Business.
- Werbach, K. (2018). *The Blockchain and the New Architecture of Trust*. Cambridge, MA: MIT Press.
- Wu, T. (2016). *The Attention Merchants: The Epic Scramble to Get Inside Our Heads*. New York: Knopf.
- Zak, P. J., & Knack, S. (2001). Trust and growth. *The Economic Journal*, 111(470), 295–321.
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
