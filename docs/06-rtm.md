# Requirements Traceability Matrix (RTM)

*AugBridge Commerce - Traceability from pain point to test case, with the reason for each link*

[← UAT Test Cases](05-uat-test-cases.md) · [README](../README.md)

---

Each row links a pain point ([BRD](02-brd.md)) to its business requirement, functional requirement ([FRD](03-frd.md)), [user story](04-user-stories.md) and [test cases](05-uat-test-cases.md).

| Pain point | BR | BR priority | FR priority | FR | User story | Test cases | Release | Why this link |
|---|---|---|---|---|---|---|---|---|
| AP-01 | (none) |  |  | (none) | (none) | (none) |  | Out of scope (BRD §6.2). |
| AP-02 | (none) |  |  | (none) | (none) | (none) |  | Out of scope: product research (BRD §7.2). |
| AP-03 | BR-01 | Must | Must | FR-01 | US-01 | TC-01a | R1 | One view of the order line replaces checking several tools; CS finds all lines by Etsy Order ID. Issue cases are added in R4 under BR-07. |
| AP-03 | BR-01 | Must | Must | FR-02 | US-02 | TC-02a, TC-13a, TC-16a | R1 (Management: R3, Designer: R4) | A shared workspace needs role-based access, which also protects the mapping. |
| AP-04 | BR-02 | Must | Must | FR-03 | US-03 | TC-03a, TC-04a | R1 | One shared Product Type-to-supplier mapping replaces choosing the supplier per order. |
| AP-04 | BR-02 | Must | Must | FR-04 | US-04 | TC-04a, TC-04b, TC-04c | R1 | The supplier comes from SKU → Product Type → mapping; Supplier 3 is assigned per line only as a fallback. |
| AP-05 | BR-03 | Must | Must | FR-05 | US-05 | TC-05a, TC-05b, TC-05c | R1 | Orders enter Lark automatically, so nothing is retyped; the daily count check covers risk R-02. |
| AP-05 | BR-03 | Must | Must | FR-06 | US-06 | TC-06a, TC-06b | R1 | Lines without the required fulfillment data are stopped before sending, which removes most supplier questions. |
| AP-05 | BR-03 | Must | Must | FR-07 | US-07 | TC-07a, TC-07b, TC-07c, TC-07d | R1 | Order data reaches Suppliers 1, 2 and 3 by API, not by typing; a failed send is logged and the line is not marked as sent. |
| AP-05 | BR-03 | Must | Should | FR-08 | US-08 | TC-08a | R3 | Supplier questions get a record and an answer. |
| AP-06, AP-08 | BR-04 | Must | Must | FR-09 | US-09 | TC-09a, TC-09b, TC-09c, TC-07c | R1 | Status and tracking come back by API and feed the queue. |
| AP-06, AP-08 | BR-04 | Must | Must | FR-10, FR-11 | US-10 | TC-10a, TC-10b, TC-10c, TC-10d, TC-10e | R1 | The queue shows only lines that need action, once per active problem (no duplicate X2 or X3); unassigned High items go to the Team Lead. |
| (none - To-Be control) | BR-04 | Must | Should | FR-12 | US-11 | TC-11a, TC-11b | R3 | Change and cancel requests use the same queue (X5) with rule BUS-01. |
| AP-07 | BR-05 | Must | Must | FR-13 | US-12 | TC-12a, TC-12b | R1 | The first tracking number of an order reaches Etsy without copying; later ones stay in Lark. |
| AP-09 | BR-06 | Should | Should | FR-14 | US-13 | TC-13a | R3 (issue rate: R4) | Current figures replace the manual weekly report. |
| AP-10 | BR-07 | Should | Should | FR-15 | US-14, US-16 | TC-14a, TC-14b, TC-16a | R4 | Every issue becomes a case with a cause and an owner, shown on its order line (R4). |
| AP-10 | BR-07 | Should | Should | FR-16 | US-15, US-16 | TC-15a, TC-15b, TC-16a | R4 | Refund or replacement is recorded; a replacement is a new order line that gets its supplier from the mapping and is checked, sent and tracked. |

## Non-functional Requirements

| NFR | Checked by | What is checked |
|---|---|---|
| **NFR-01 Speed** | UAT: TC-05a, TC-13a. Technical check in R1: hourly schedule | UAT checks order intake time and dashboard freshness by source. UAT starts the hourly check by hand, so it does not prove the schedule. The Developer confirms the schedule in R1. |
| **NFR-02 No silent failures** | TC-05c, TC-07d, TC-09c, TC-12b | Missing orders, failed sends, failed supplier updates and failed tracking syncs are logged and shown |
| **NFR-03 History** | TC-10c, TC-14b | Status History for lines, exceptions and issue cases |
| **NFR-04 Personal data** | Not in UAT | Data policy agreed with the vendor before go-live |
| **NFR-05 Data volume** | Not in UAT | Plan limits checked before the pilot; peak volume checked in R5 |

---

[← UAT Test Cases](05-uat-test-cases.md) · [README](../README.md)
