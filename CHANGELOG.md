# Changelog

## 0.0.1 — 2026-09-02

Skeleton. The harness that will build businesses starts, like anvil did, with its own gate.

- `scripts/score-guild.sh` — scoring seam: `pass-rate` (7 weighted dimensions, EVIDENCE GATE cap),
  `coverage` (VRS `V-n` traceability), `verdict` (`NOT_READY | OPEN_FOR_BUSINESS | FIRST_CUSTOMER`;
  the last requires a human-entered `won` pipeline row carrying invoice + payment evidence).
- `scripts/score-e2e-capability.sh` — **frozen** 39-row end-to-end capability scorer
  (CORE / EVID / DISC / ECON / GTM / OPS / GOV / PROD). Baseline recorded in the README.
- `tests/score.test.sh` + fixtures — the seam's own self-test (filter arg; zero matches = fail).
- `scripts/sync-plugin.sh`, `doctor.sh`, `validate-handoff.sh` — mirror parity, toolchain check,
  handoff gate, ported from anvil.
- `SKILL.md` + `references/metrics.md` — doctrine, safety invariants, scoring contract.
