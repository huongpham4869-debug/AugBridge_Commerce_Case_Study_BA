# User Stories

*AugBridge Commerce - Requirements Written From The User’s Point Of View*

[← FRD](03-frd.md) · [README](../README.md) · [UAT Test Cases →](05-uat-test-cases.md)

---

16 user stories, grouped by business requirement. Each story links to its functional requirement (FR) in the [FRD](03-frd.md#8-functional-requirements).

| ID | Role | Business requirement | FR | Priority |
|---|---|---|---|---|
| [US-01](#us-01) | CS | BR-01 | FR-01 | Must |
| [US-02](#us-02) | Team Lead | BR-01 | FR-02 | Must |
| [US-03](#us-03) | PD | BR-02 | FR-03 | Must |
| [US-04](#us-04) | CS | BR-02 | FR-04 | Must |
| [US-05](#us-05) | CS | BR-03 | FR-05 | Must |
| [US-06](#us-06) | CS | BR-03 | FR-06 | Must |
| [US-07](#us-07) | CS | BR-03 | FR-07 | Must |
| [US-08](#us-08) | CS | BR-03 | FR-08 | Should |
| [US-09](#us-09) | CS | BR-04 | FR-09 | Must |
| [US-10](#us-10) | CS | BR-04 | FR-10, FR-11 | Must |
| [US-11](#us-11) | CS | BR-04 | FR-12 | Should |
| [US-12](#us-12) | CS | BR-05 | FR-13 | Must |
| [US-13](#us-13) | Team Lead or Management | BR-06 | FR-14 | Should |
| [US-14](#us-14) | CS | BR-07 | FR-15 | Should |
| [US-15](#us-15) | CS | BR-07 | FR-16 | Should |
| [US-16](#us-16) | Designer | BR-07 | FR-15, FR-16 | Should |

## BR-01 – One shared place for order data

### US-01

**As a CS, I want to see all key information about an order line in one place, so that I do not need to check other tools.**

FR: FR-01 · Priority: Must

Acceptance criteria:

1. Given an order line with a supplier, tracking number, and open exceptions, when CS opens the line, then these details are shown in one place.
2. Given an Etsy order with two or more order lines, when CS searches by Etsy Order ID, then all order lines are shown with their line, SKU, Product Type, supplier, status, tracking, and open exceptions.

### US-02

**As a Team Lead, I want each role to access only the data and actions it needs, so that sensitive data is not exposed unnecessarily and supplier mapping cannot be changed by the wrong user.**

FR: FR-02 · Priority: Must

Acceptance criteria:

1. Given a CS, Designer, or Team Lead user, when they try to change the Supplier Mapping, then the change is blocked.
2. Given a Designer or Management user, when they log in, then the Designer can see only assigned design cases and linked order lines, while Management can access only the dashboard.

## BR-02 – Product Type-to-supplier mapping

### US-03

**As a PD, I want to maintain the Product Type-to-supplier mapping with effective dates, so that new order lines use the correct supplier and mapping history is kept.**

FR: FR-03 · Priority: Must

Acceptance criteria:

1. Given MUG-11OZ is mapped to Supplier 1, when PD maps it to Supplier 2 from a new start date, then lines assigned after that date use Supplier 2, while lines already Ready to send or later keep Supplier 1 and the previous mapping is kept with an end date.
2. Given a new Product/Design Task uses Product Type MUG-11OZ, when its SKU is ordered for the first time, then the line uses the supplier currently mapped to MUG-11OZ and the mapping is not changed.

### US-04

**As CS, I want the preferred supplier to be assigned automatically, so that I do not need to choose a supplier for every order line.**

FR: FR-04 · Priority: Must

Acceptance criteria:

1. Given SKU-A and SKU-B both have Product Type MUG-11OZ, and MUG-11OZ is mapped to Supplier 1, when the lines are processed, then both lines are assigned to Supplier 1.
2. Given an order contains lines whose Product Types are mapped to different suppliers, when the order is processed, then each line is assigned its preferred supplier and the lines are sent separately.
3. Given a valid SKU has no active supplier mapping for its Product Type, when the line is processed, then it gets X1 with reason NO_ACTIVE_SUPPLIER_MAPPING, PD is notified, and the line is checked again after the mapping is added.
4. Given a supplier rejects a line because it cannot fulfill it, then the line gets X1. When CS assigns Supplier 3 with a fallback reason, then only that line uses Supplier 3; its preferred supplier and Product Type mapping do not change.

## BR-03 – Orders reach the supplier without retyping

### US-05

**As CS, I want Etsy orders to appear in Lark automatically, so that I do not need to re-enter them.**

FR: FR-05 · Priority: Must

Acceptance criteria:

1. Given a new Etsy order, when the order event is received, then the order and one order line per item appear in Lark within 15 minutes.
2. Given an order already exists in Lark, when the same order event is received again, then no duplicate order is created.
3. Given an Etsy order is missing in Lark, when the daily count check runs, then the Developer receives an alert showing the shop and the difference.

### US-06

**As CS, I want incomplete order lines to be stopped before they reach the supplier, so that missing information can be fixed before submission.**

FR: FR-06 · Priority: Must

Acceptance criteria:

1. Given an order line is missing required fulfillment data, such as a complete shipping address, quantity, or artwork, when the line is checked, then it gets X1 with reason MISSING_ORDER_DETAILS, the failed check is shown, and the line is not sent.
2. Given the SKU cannot be found in Lark, when the line is checked, then it gets X1 with reason INVALID_SKU and is not sent. CS corrects the SKU, and PD is notified so the listing can be fixed.
3. Given the issue is fixed and the line passes validation, then X1 is resolved and the line becomes Ready to send.

### US-07

**As CS, I want orders to be sent to suppliers automatically, so that I save time and reduce manual entry errors.**

FR: FR-07 · Priority: Must

Acceptance criteria:

1. Given a Ready to send line with Supplier 1 or 2 as its preferred supplier, when the send step runs, then the supplier receives the order details, personalization text, applicable artwork, and shipping address through the API. If accepted, the line becomes Sent to supplier.
2. Given CS has assigned Supplier 3 to a line as a fallback, when the send step runs, then Supplier 3 receives the same required data through the API and the line becomes Sent to supplier when accepted.
3. Given the supplier order API fails, then the failure is logged, the line stays Ready to send, and it is not marked as sent.

### US-08

**As CS, I want to record supplier notifications against an order line, so that information requiring action is not lost in chat.**

FR: FR-08 · Priority: Should

Acceptance criteria:

1. Given a supplier sends a notification that requires CS action, when CS records it against the order line, then X4 appears in the exception queue.
2. Given an X4 exception, when CS closes it, then a resolution or response note is required.

## BR-04 – One queue for lines that need action

### US-09

**As CS, I want supplier status and tracking to update in Lark, so that I do not need to check supplier systems order by order.**

FR: FR-09 · Priority: Must

Acceptance criteria:

1. Given an order line with Supplier 1, 2, or 3, when the supplier sends a status or tracking update through its API, then Lark shows the updated status, tracking number, and relevant dates.
2. Given a supplier API update fails, then the failure is logged and shown, and the order line is not changed by the failed update.

### US-10

**As CS, I want to see only the order lines that need action, with the most urgent items first, so that I do not need to check every order manually.**

FR: FR-10, FR-11 · Priority: Must

Acceptance criteria:

1. Given a line stays in a status longer than its expected time, when the hourly check runs, then it gets X2. Lines within their expected time are not added to the exception queue.
2. Given a line is not shipped and no open exception covers the same issue, when the hourly check finds that its expected ship date is after the Etsy ship-by date, or the ship-by date is 1 business day away or less, then it gets X3. X3 is High when the ship-by date has passed or is 1 business day away or less.
3. Given an open exception already covers the same unresolved issue, when the hourly check finds the line stuck or at risk, then no duplicate X2 or X3 is created. The existing exception is shown once and its priority is updated when needed.
4. Given an Open exception, when CS takes it, then it becomes In Progress with that CS user as owner. When the resolution condition is met, it becomes Resolved and leaves the queue.
5. Given a High-priority exception stays Open without an owner for more than 2 working hours, when the hourly check runs, then the Team Lead is notified.
6. The queue shows High-priority exceptions first, then sorts by ship-by date.

### US-11

**As CS, I want to handle customer change or cancel requests based on production status, so that I do not change or cancel a line after production has started.**

FR: FR-12 · Priority: Should

Acceptance criteria:

1. Given a line is not yet In production, when CS logs a change or cancel request as X5 and the supplier confirms it, then the line is updated or canceled, and X5 is closed with the confirmation recorded.
2. Given a line is In production or later, when CS tries to change its details or cancel it, then the system blocks the action. CS informs the customer and closes X5 with an answer note.

## BR-05 – Tracking to Etsy

### US-12

**As CS, I want the first tracking number for an Etsy order to be synced to Etsy automatically while keeping all tracking numbers on their order lines in Lark, so that customers receive a shipping update and CS can find other tracking numbers when needed.**

FR: FR-13 · Priority: Must

Acceptance criteria:

1. Given an Etsy order does not yet have a tracking number on Etsy, when one of its order lines receives a tracking number, then the first tracking number is synced to the Etsy order.
2. Given the first tracking number has already been synced, when another order line receives a tracking number, then that tracking number is saved on its own line in Lark, is not synced to Etsy automatically, and does not create X6.
3. Given the selected tracking number fails to sync, then the line gets X6, the failure is logged, and CS can add the tracking number to Etsy manually and resolve X6 after confirming it is on Etsy.

## BR-06 – Operational dashboard

### US-13

**As a Team Lead or Management, I want an operational dashboard, so that I can see current operational issues without relying on a manual weekly report.**

FR: FR-14 · Priority: Should

Acceptance criteria:

1. Given a Team Lead or Management user opens the dashboard, then it shows orders from the last 7 days, open exceptions by reason and supplier, late shipment rate, issue rate from R4, and average order-to-delivery time as a trend.
2. Given dashboard data comes from different sources, when the dashboard is opened, then Lark-based figures are no more than 15 minutes old and supplier figures reflect the latest update received.

## BR-07 – Customer issue cases

### US-14

**As CS, I want to record each customer issue as a case with a cause, so that it can be tracked and assigned to the right person.**

FR: FR-15 · Priority: Should

Acceptance criteria:

1. Given a customer reports an issue, when CS saves the case without a cause, then the case cannot be saved.
2. Given the cause is Design, Supplier, or Customer, when the case is saved, then Design cases are assigned to a Designer, Supplier cases are linked to the supplier and their communication and result are recorded by CS, and Customer cases remain with CS.
3. The case records when it was opened and closed and is shown on its linked order line.

### US-15

**As CS, I want to record the customer’s choice and create a replacement as a normal order line, so that the replacement follows the same fulfillment process as other order lines.**

FR: FR-16 · Priority: Should

Acceptance criteria:

1. Given the customer chooses a replacement, when CS records the choice, then a new order line linked to the issue case is created and gets its preferred supplier from the Product Type mapping.
2. Given a Design case where the design was changed, when CS tries to create the replacement before customer approval is recorded, then the action is blocked.
3. Given a replacement line exists for a Design case, when the Designer attaches the approved replacement artwork, then the line passes the artwork check and can be sent to the supplier.
4. Given the customer chooses a refund, when CS records the choice, then the choice is saved on the case. The refund itself is handled in Etsy.

### US-16

**As a Designer, I want to see the design cases assigned to me and attach approved replacement artwork to the replacement line, so that CS can send the corrected artwork to the supplier.**

FR: FR-15, FR-16 · Priority: Should

Acceptance criteria:

1. Given a Design case is assigned to a Designer, when the Designer logs in, then they can see the case, its linked order-line details, and the customer issue, but not other cases, the exception queue, or the Supplier Mapping.
2. Given customer approval has been recorded and the replacement line exists, when the Designer attaches the approved artwork, then CS can see the file on the line and the line is checked again under FR-06.

---

[← FRD](03-frd.md) · [README](../README.md) · [UAT Test Cases →](05-uat-test-cases.md)
