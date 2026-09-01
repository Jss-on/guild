# as_of: 2026-09-02

# Venture Requirements Spec — fixture, bad (planted defects)

Four of the five rows fail measurability: V-1 is the riskiest assumption but is tested by desk
research only; V-2 carries an adjective where a threshold belongs; V-4 is stated as a fact, not a
"We believe" hypothesis; V-5 has no owner and no decide-by date. Only V-3 is measurable.

```vrs
id: V-1
statement: We believe that Metro Manila SMB manufacturers with manual counts will pay at least PHP 15,000 per month for automated stock counts
type: D
metric: reported willingness to pay in desk research on comparable tools
threshold: >= 3 comparable tools priced at >= PHP 15,000 per month
method: desk
evidence_grade: weak
risk_rank: 1
owner: founder-1
decide_by: 2026-11-30
```

```vrs
id: V-2
statement: We believe that the owner, not the plant manager, signs within 30 days of a site walk-through
type: D
metric: share of walk-throughs that convert to a signed LOI
threshold: high
method: LOI
evidence_grade: moderate
risk_rank: 2
owner: founder-2
decide_by: 2026-11-15
```

```vrs
id: V-3
statement: We believe that owners will place a PHP 10,000 deposit for a paid discovery workshop before any build exists
type: D
metric: deposits received for the paid discovery offer
threshold: >= 3 deposits of >= PHP 10,000 by decide_by
method: paid_pilot
evidence_grade: strong
risk_rank: 3
owner: founder-1
decide_by: 2026-10-31
```

```vrs
id: V-4
statement: Owners sign within 30 days because the count is their biggest pain
type: D
metric: days from walk-through to signed LOI
threshold: <= 30 days for >= 50 % of walk-throughs
method: LOI
evidence_grade: moderate
risk_rank: 4
owner: founder-2
decide_by: 2026-11-15
```

```vrs
id: V-5
statement: We believe that a camera-and-scale count station reaches 97 % count accuracy on sacks and drums
type: F
metric: count accuracy versus a manual audit count
threshold: >= 97 % on >= 200 items
method: desk
evidence_grade: weak
risk_rank: 5
```
