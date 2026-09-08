# Independent verification — the record, including what people disagreed with

This file exists to be filled in by people who are not us.

**Nothing here is verified by anyone outside The Dark Factory yet.** When that changes, it will be
recorded below — including anything a reviewer disagreed with, got a different result for, or
thought was worthless. **A verification record that only carries agreement is not a verification
record.**

---

## Two different things you could check, and the second is the one we need

### 1. Reproducibility — cheap, and mostly already guaranteed
Take the ten `.ads` files, put them in an empty directory with `check.gpr`, and run:

```
gnatprove -P check.gpr --level=2
```

Expect **181 checks, 0 unproved, 0 justified** — 56 functional contracts, 77 run-time checks,
48 termination. Also worth doing: `--prover=z3`, `--prover=cvc5` and `--prover=altergo`
separately, to confirm our own statement that this set is **not** 3/3 (Z3 alone 1 unproved,
CVC5 alone 1, Alt-Ergo alone 2).

This establishes that the machinery does what we say. It does **not** establish that any of it
matters.

### 2. ★ Whether the contracts are worth anything — expensive, and the real request

**Read the postconditions and tell us whether they say something worth saying.**

A proof establishes that the code satisfies the property *as written*. If the property is trivial,
or does not capture what the original actually guarantees, the proof is sound and useless. **No
amount of re-running touches this.** It needs somebody who knows the domain, or knows SPARK, or
both, to look at a contract and judge it.

Questions worth answering, if you are minded to:

- Is the stated property actually load-bearing, or is it a restatement of the implementation?
- Does it capture what the original C/Fortran/Mortran relies on, or something adjacent to it?
- Is there an obvious stronger property we should have stated and did not?
- Is the modelling choice wrong — bounded integers where a different type would say more?

⚠ **We have not proved equivalence with the original**, and do not claim it. The correspondence
between each core and its upstream source is human reading. **That is the weakest link in the
whole chain**, and it is where a reviewer's time is worth most.

---

## What we will do with what you tell us

- **Record it here, under your name if you want it, anonymously if you prefer.**
- **Publish disagreements unedited.** If you conclude a contract is trivial, that goes in this file
  in your words, not our summary of them. If we think you are wrong we will say so underneath and
  you get the last word.
- **Fix what should be fixed**, and say what we changed and why.
- ⛔ **We will not quietly drop a criticism**, and we will not describe a reviewer as endorsing
  something they did not.

Open an issue on this repository, or write to us. There is no form.

---

## The record

*(empty — nobody outside The Dark Factory has checked this yet)*

| date | who | what they checked | what they found |
|---|---|---|---|
| — | — | — | — |
