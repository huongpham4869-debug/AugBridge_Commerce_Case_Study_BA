# UAT Test Cases

*AugBridge Commerce - How business behavior will be checked*

[← User Stories](04-user-stories.md) · [README](../README.md) · [RTM →](06-rtm.md)

---

> **Not run.** The solution is not built, so the Actual Result and Status columns are blank. The Excel file with all columns is in [`original-files/`](../original-files).

## Summary

| Item | Count |
|---|---|
| Total test cases | 34 |
| P1 (must pass before its release goes live) | 33 |
| P2 (can go live with a workaround) | 1 |
| Negative test cases | 13 |
| Technical checks (Developer runs, users witness) | 5 |

## Test setup

| Item | Detail |
|---|---|
| **Environment** | Lark test base, Etsy test shop, and test API access for Suppliers 1 and 2 (primary) and Supplier 3 (backup). Supplier 1 standard production days = 4. |
| **Test data** | 2 shops. 3 Product Types: MUG-11OZ (mapped to Supplier 1), TSHIRT-UNISEX (mapped to Supplier 2), POSTER-A3 (no active mapping). 6 SKUs, written here as SKU-A to SKU-F, each listed on one test shop; real SKUs use the task format, for example 061026-Dung-05. SKU-A and SKU-B (MUG-11OZ), SKU-C (TSHIRT-UNISEX), SKU-D (POSTER-A3), SKU-E (a wrong SKU on an Etsy listing; no Product/SKU record in Lark), SKU-F (MUG-11OZ, no standard artwork link). Orders: normal, with personalization text, missing details, incomplete address, quantity 0, one order (10482) with two lines for two suppliers, a line the preferred supplier cannot fulfill, ship-by date tomorrow, expected to miss the ship-by date, stuck in production, open High exceptions with no owner. Cases: Design (D1 on a Supplier 1 line, with a replacement artwork file; D2 assigned to another Designer), Supplier, Customer. |
| **Users** | PD&CS accounts with the PD (mapping owner) permission or the CS permission, plus one account each for Designer, Team Lead, Management and Developer |
| **Priority** | P1 = must pass before the release that contains the test goes live (Release column). P2 = can go live with a written workaround. |
| **Exit criteria** | For each release: all P1 test cases for that release pass and no P1 defect is open (FRD §11). |
| **Status values** | Pass, Fail, Blocked, Not run (blank until the test is run). |
| **Technical checks** | TC-05b, TC-05c, TC-07d, TC-09c and TC-12b need a test tool or a simulated failure. The Developer runs them and a business user witnesses the result. They stay in this pack because they protect business behavior: no duplicate orders, no missing orders, and no silent send, status-update or tracking failure. |
| **Not in UAT** | Peak-season effort for BR-04 is checked in release R5 with real data (FRD §11). The hourly schedule (NFR-01) is a technical check: the Developer confirms it in R1. In UAT the check is started by hand, so UAT tests the exception rules, not the schedule. Team Lead (view only) and Developer (admin) access are confirmed at role setup in R1. |

## Test case list

| TC ID | US | Scenario | Priority | Release |
|---|---|---|---|---|
| [TC-01a](#tc-01a) | US-01 | Search by Etsy Order ID and view an order line | P1 | R1 |
| [TC-02a](#tc-02a) | US-02 | CS cannot change the supplier mapping (negative) | P1 | R1 |
| [TC-03a](#tc-03a) | US-03 | Mapping change with a start date: Ready to send and sent lines keep their supplier | P1 | R1 |
| [TC-04a](#tc-04a) | US-04 | One order with lines for different suppliers: the supplier comes from the Product Type | P1 | R1 |
| [TC-04b](#tc-04b) | US-04 | Valid SKU, but no active mapping for its Product Type (negative) | P1 | R1 |
| [TC-04c](#tc-04c) | US-04 | Supplier rejects a line by API; X1 is raised and CS assigns Supplier 3 (negative) | P1 | R1 |
| [TC-05a](#tc-05a) | US-05 | New Etsy order appears in Lark | P1 | R1 |
| [TC-05b](#tc-05b) | US-05 | [Technical check] Same order event received twice (negative) | P1 | R1 |
| [TC-05c](#tc-05c) | US-05 | [Technical check] Daily count check finds a missing order (negative) | P1 | R1 |
| [TC-06a](#tc-06a) | US-06 | Incomplete order is stopped, then sent after the fix (negative) | P1 | R1 |
| [TC-06b](#tc-06b) | US-06 | Invalid SKU, missing artwork and quantity 0 are stopped (negative) | P1 | R1 |
| [TC-07a](#tc-07a) | US-07 | Send an order to a primary supplier by API (Supplier 1) | P1 | R1 |
| [TC-07b](#tc-07b) | US-07 | Send an order to the other primary supplier by API (Supplier 2) | P1 | R1 |
| [TC-07c](#tc-07c) | US-07, US-09 | Backup supplier by API: fallback line is sent, status and tracking come back (Supplier 3) | P1 | R1 |
| [TC-07d](#tc-07d) | US-07 | [Technical check] Supplier order API fails when sending (negative) | P1 | R1 |
| [TC-08a](#tc-08a) | US-08 | Log a supplier question | P1 | R3 |
| [TC-09a](#tc-09a) | US-09 | Status and tracking from a supplier API | P1 | R1 |
| [TC-09b](#tc-09b) | US-09 | Supplier confirms the order by API | P1 | R1 |
| [TC-09c](#tc-09c) | US-09 | [Technical check] Supplier API update fails (negative) | P1 | R1 |
| [TC-10a](#tc-10a) | US-10 | Hourly check flags only the stuck line (X2) | P1 | R1 |
| [TC-10b](#tc-10b) | US-10 | Ship-by date at risk (X3): flagged early, and High near the deadline | P1 | R1 |
| [TC-10c](#tc-10c) | US-10 | Take an exception; it closes by itself; history is saved | P1 | R1 |
| [TC-10d](#tc-10d) | US-10 | No duplicate X2 or X3 when an open exception already covers the issue | P1 | R1 |
| [TC-10e](#tc-10e) | US-10 | Unassigned High exception is escalated to the Team Lead | P1 | R1 |
| [TC-11a](#tc-11a) | US-11 | Change or cancel before production | P1 | R3 |
| [TC-11b](#tc-11b) | US-11 | Change or cancel after production starts (negative) | P1 | R3 |
| [TC-12a](#tc-12a) | US-12 | One order, two suppliers: first tracking goes to Etsy, later tracking stays in Lark | P1 | R1 |
| [TC-12b](#tc-12b) | US-12 | [Technical check] Tracking sync fails (negative) | P1 | R1 |
| [TC-13a](#tc-13a) | US-13 | Operational dashboard | P2 | R3 (issue rate: R4) |
| [TC-14a](#tc-14a) | US-14 | A case needs a cause (negative) | P1 | R4 |
| [TC-14b](#tc-14b) | US-14 | Case routing by cause; case history is saved | P1 | R4 |
| [TC-15a](#tc-15a) | US-15 | Record refund or replacement | P1 | R4 |
| [TC-15b](#tc-15b) | US-15 | Replacement blocked before design approval; artwork linked after approval (negative) | P1 | R4 |
| [TC-16a](#tc-16a) | US-16, US-02 | Designer sees only assigned design cases and attaches replacement artwork | P1 | R4 |

## Test case details

### TC-01a

**Search by Etsy Order ID and view an order line**

User story: US-01 · Priority: P1 · Release: R1

**Preconditions:** Etsy order 10479 has two lines. Line L1 (10479-1) is Shipped and has 1 open exception.

**Steps:**

1. Log in as CS.
2. Search for Etsy Order ID 10479.
3. Open line L1.

**Test data:** Order 10479 (2 lines)

**Expected result:** Step 2: both lines of order 10479 are listed, each with its SKU, Product Type, supplier, status, tracking and open exception. Step 3: order details, supplier, status, tracking number and the open exception show on one screen.

### TC-02a

**CS cannot change the supplier mapping (negative)**

User story: US-02 · Priority: P1 · Release: R1

**Preconditions:** MUG-11OZ has an active mapping

**Steps:**

1. Log in as a CS user (no mapping-owner permission).
2. Open Supplier Mapping.
3. Try to change the supplier for MUG-11OZ.

**Test data:** CS account, MUG-11OZ

**Expected result:** The change is blocked. A message says only the PD (mapping owner) permission can change the mapping. The mapping is unchanged.

### TC-03a

**Mapping change with a start date: Ready to send and sent lines keep their supplier**

User story: US-03 · Priority: P1 · Release: R1

**Preconditions:** MUG-11OZ is mapped to Supplier 1. SKU-A and SKU-B belong to MUG-11OZ. Line L9 (SKU-A) is Ready to send with Supplier 1. Line L10 (SKU-A) is Sent to supplier with Supplier 1.

**Steps:**

1. Log in as a user with the PD (mapping owner) permission.
2. Map MUG-11OZ to Supplier 2 from today.
3. Place a new test order with SKU-A and SKU-B.
4. Open L9 and L10.

**Test data:** MUG-11OZ (SKU-A, SKU-B), lines L9 and L10, Suppliers 1 and 2

**Expected result:** Both new lines get Supplier 2. L9 (Ready to send) and L10 (sent) stay with Supplier 1 and are not reassigned. The old mapping is kept with an end date.

### TC-04a

**One order with lines for different suppliers: the supplier comes from the Product Type**

User story: US-04 · Priority: P1 · Release: R1

**Preconditions:** SKU-A and SKU-B belong to MUG-11OZ, mapped to Supplier 1. SKU-C belongs to TSHIRT-UNISEX, mapped to Supplier 2.

**Steps:**

1. Place a test order with SKU-A, SKU-B and SKU-C.
2. Open the order in Lark.

**Test data:** Order with SKU-A + SKU-B + SKU-C

**Expected result:** The SKU-A and SKU-B lines both get Supplier 1 as preferred supplier from the MUG-11OZ mapping; no supplier is stored per SKU. The SKU-C line gets Supplier 2. Each line is processed on its own, and lines for the two suppliers are sent separately.

### TC-04b

**Valid SKU, but no active mapping for its Product Type (negative)**

User story: US-04 · Priority: P1 · Release: R1

**Preconditions:** SKU-D is a valid SKU and belongs to POSTER-A3, which has no active mapping

**Steps:**

1. Place a test order with SKU-D.
2. Log in as CS and open the queue.
3. As PD, map POSTER-A3 to Supplier 2 from today.
4. Open the line again.

**Test data:** SKU-D (POSTER-A3)

**Expected result:** Step 2: the line has X1 (Cannot send) with reason NO_ACTIVE_SUPPLIER_MAPPING and is not sent; PD gets a notification. Step 4: the line was checked again, X1 is resolved, and the line has Supplier 2 as preferred supplier and is Ready to send.

### TC-04c

**Supplier rejects a line by API; X1 is raised and CS assigns Supplier 3 (negative)**

User story: US-04 · Priority: P1 · Release: R1

**Preconditions:** MUG-11OZ is mapped to Supplier 1. Line L7 (SKU-A) is Ready to send for Supplier 1. The Supplier 1 test system is set to reject it as out of stock.

**Steps:**

1. Let the send step run.
2. Open the queue without running the hourly check.
3. Try to assign Supplier 3 without a fallback reason.
4. Assign Supplier 3 with the fallback reason OUT_OF_STOCK.
5. Open L7 and the Supplier Mapping.

**Test data:** Line L7 (SKU-A), Suppliers 1 and 3

**Expected result:** Step 2: L7 already has X1 with reason SUPPLIER_CANNOT_FULFILL. Step 3 is blocked. Step 4: L7 shows preferred supplier = Supplier 1, supplier = Supplier 3 and fallback reason OUT_OF_STOCK; X1 is resolved and L7 is ready to be sent to Supplier 3. Step 5: the mapping for MUG-11OZ is still Supplier 1, and only L7 uses Supplier 3.

### TC-05a

**New Etsy order appears in Lark**

User story: US-05 · Priority: P1 · Release: R1

**Preconditions:** Etsy test shop is connected

**Steps:**

1. Place an order with 2 items in the Etsy test shop, one with personalization text.
2. Wait up to 15 minutes.
3. Search for the order in Lark.

**Test data:** Etsy test order, 2 items, one with personalization text

**Expected result:** The order and both lines appear in Lark within 15 minutes. The personalization text is on its order line.

### TC-05b

**[Technical check] Same order event received twice (negative)**

User story: US-05 · Priority: P1 · Release: R1

**Preconditions:** Order O1 is already in Lark

**Steps:**

1. Send the order event for O1 again (test tool).
2. Search for O1 in Lark.

**Test data:** Repeated event for O1

**Expected result:** Lark still has only one order O1 with the same lines.

### TC-05c

**[Technical check] Daily count check finds a missing order (negative)**

User story: US-05 · Priority: P1 · Release: R1

**Preconditions:** One test order is removed from the Lark test base

**Steps:**

1. Run the daily count check.

**Test data:** Etsy test shop, 1 missing order

**Expected result:** The Developer gets an alert with the shop name and the difference.

### TC-06a

**Incomplete order is stopped, then sent after the fix (negative)**

User story: US-06 · Priority: P1 · Release: R1

**Preconditions:** SKU-A is in Lark with a standard artwork link

**Steps:**

1. Place an order for SKU-A with an incomplete shipping address (test data).
2. Check the line in Lark.
3. As CS, complete the address.

**Test data:** SKU-A, incomplete address

**Expected result:** Step 2: the line gets X1 (MISSING_ORDER_DETAILS) and is not sent. Step 3: the line is checked again, X1 is resolved and the line moves to Ready to send.

### TC-06b

**Invalid SKU, missing artwork and quantity 0 are stopped (negative)**

User story: US-06 · Priority: P1 · Release: R1

**Preconditions:** SKU-E was entered on an Etsy test listing by mistake and has no Product/SKU record in Lark. SKU-F is in Lark with a Product Type but has no standard artwork link.

**Steps:**

1. Place an order for SKU-E.
2. Place an order for SKU-F.
3. Send an order event for SKU-A with quantity 0 (test tool).
4. Check the three lines in Lark.
5. As CS, correct the SKU on the first line to SKU-A.

**Test data:** SKU-E (wrong SKU, no record in Lark), SKU-F (no artwork link), order with quantity 0

**Expected result:** Step 4: the SKU-E line has X1 with reason INVALID_SKU. The other two lines have X1 with reason MISSING_ORDER_DETAILS and show which check failed. No line is sent. Step 5: the line resolves to MUG-11OZ and gets Supplier 1; X1 is resolved and the line moves to Ready to send.

### TC-07a

**Send an order to a primary supplier by API (Supplier 1)**

User story: US-07 · Priority: P1 · Release: R1

**Preconditions:** A line for SKU-A is Ready to send. MUG-11OZ is mapped to Supplier 1.

**Steps:**

1. Let sending run.
2. Check the supplier test system.
3. Check the line in Lark.

**Test data:** Line for Supplier 1

**Expected result:** The supplier receives the order details, personalization text, standard artwork link and address. The line becomes Sent to supplier.

### TC-07b

**Send an order to the other primary supplier by API (Supplier 2)**

User story: US-07 · Priority: P1 · Release: R1

**Preconditions:** A line for SKU-C is Ready to send. TSHIRT-UNISEX is mapped to Supplier 2.

**Steps:**

1. Let the send step run.
2. Check the Supplier 2 test system.
3. Check the line in Lark.

**Test data:** Line for Supplier 2

**Expected result:** Supplier 2 receives the order details, personalization text, standard artwork link and address. The line becomes Sent to supplier.

### TC-07c

**Backup supplier by API: fallback line is sent, status and tracking come back (Supplier 3)**

User story: US-07, US-09 · Priority: P1 · Release: R1

**Preconditions:** Line L7 was moved to Supplier 3 (TC-04c) and is Ready to send.

**Steps:**

1. Let the send step run.
2. Check the Supplier 3 test system.
3. In the Supplier 3 test system, mark the line shipped with a tracking number.
4. Open L7 in Lark.
5. Open the order in the Etsy test shop.

**Test data:** Line L7 (Supplier 3)

**Expected result:** Step 2: Supplier 3 receives the order details, personalization text, artwork link and address. L7 is Sent to supplier. Step 4: L7 shows Shipped, the tracking number and the ship date; preferred supplier is still Supplier 1. Step 5: the tracking number is on the Etsy order.

### TC-07d

**[Technical check] Supplier order API fails when sending (negative)**

User story: US-07 · Priority: P1 · Release: R1

**Preconditions:** A line for SKU-A is Ready to send for Supplier 1. The Supplier 1 order API is unavailable (simulated).

**Steps:**

1. Let the send step run.
2. Check the line and the log.
3. Set the line's time in status beyond the agreed Ready to send threshold (test data).
4. Start the hourly check by hand and open the queue.

**Test data:** Simulated Supplier 1 API outage

**Expected result:** Step 2: the failed send is logged and shown (NFR-02). The line stays Ready to send and is not marked Sent to supplier. Step 4: the line has X2 (Stuck in status).

### TC-08a

**Log a supplier question**

User story: US-08 · Priority: P1 · Release: R3

**Preconditions:** A line is Sent to supplier

**Steps:**

1. As CS, log a supplier question on the line.
2. Try to close it without a note.
3. Add an answer note and close it.

**Test data:** Any sent line

**Expected result:** X4 appears in the queue. Step 2 is blocked. Step 3 closes X4.

### TC-09a

**Status and tracking from a supplier API**

User story: US-09 · Priority: P1 · Release: R1

**Preconditions:** A line is In production with Supplier 2

**Steps:**

1. In the supplier test system, mark the line shipped with a tracking number.
2. Open the line in Lark.

**Test data:** Line for Supplier 2

**Expected result:** The line shows Shipped, the tracking number and the ship date.

### TC-09b

**Supplier confirms the order by API**

User story: US-09 · Priority: P1 · Release: R1

**Preconditions:** A line is Sent to supplier with Supplier 1

**Steps:**

1. In the Supplier 1 test system, confirm the order.
2. Open the line in Lark.

**Test data:** Line for Supplier 1

**Expected result:** The line shows In production, with the time of the change. The expected time in status now uses Supplier 1's standard production days.

### TC-09c

**[Technical check] Supplier API update fails (negative)**

User story: US-09 · Priority: P1 · Release: R1

**Preconditions:** A line is In production with Supplier 2. The Supplier 2 API is unavailable (simulated).

**Steps:**

1. In the Supplier 2 test system, mark the line shipped.
2. Let the status update run.
3. Check the line and the log.

**Test data:** Simulated Supplier 2 API outage

**Expected result:** The failed update is logged and shown to the Developer. The line is not changed and stays In production (NFR-02).

### TC-10a

**Hourly check flags only the stuck line (X2)**

User story: US-10 · Priority: P1 · Release: R1

**Preconditions:** Supplier 1 standard production days = 4. L1 is In production for 5 business days, L2 for 2 business days.

**Steps:**

1. Start the hourly check by hand.
2. Open the queue.

**Test data:** Lines L1 and L2

**Expected result:** L1 has X2 (Stuck in status). L2 is not in the queue.

### TC-10b

**Ship-by date at risk (X3): flagged early, and High near the deadline**

User story: US-10 · Priority: P1 · Release: R1

**Preconditions:** Supplier 1 standard production days = 4. No line has an open exception. L3 was sent to Supplier 1 today; ship-by date in 2 business days. L4 was sent today; ship-by date in 6 business days. L5 is In production for 3 business days; ship-by date is tomorrow.

**Steps:**

1. Start the hourly check by hand.
2. Open the queue.

**Test data:** Lines L3, L4 and L5

**Expected result:** L3 has X3 with Normal priority, because its expected ship date is after its ship-by date. L4 is not in the queue. L5 has X3 with High priority and is shown above L3.

### TC-10c

**Take an exception; it closes by itself; history is saved**

User story: US-10 · Priority: P1 · Release: R1

**Preconditions:** A line has an Open X2 exception

**Steps:**

1. As CS, take the exception.
2. The supplier marks the line shipped.
3. Open the queue.
4. Open the Status History of the line and of the exception.

**Test data:** Line with X2

**Expected result:** Step 1: status In Progress, owner = this CS user. Step 3: the exception is Resolved and not in the queue. Step 4: each change is saved with the old status, the new status, the time and who made it (line In production → Shipped by the system; exception Open → In Progress by the CS user, In Progress → Resolved by the system) (NFR-03).

### TC-10d

**No duplicate X2 or X3 when an open exception already covers the issue**

User story: US-10 · Priority: P1 · Release: R1

**Preconditions:** L6 was sent to Supplier 1 two business days ago. It has an Open X2 with Normal priority. Its ship-by date is in 2 business days. L11 has an Open X1 (SUPPLIER_CANNOT_FULFILL) and has stayed Ready to send beyond its expected time.

**Steps:**

1. Change the ship-by date of L6 to tomorrow (test data).
2. Start the hourly check by hand.
3. Open the queue.

**Test data:** Line L6 with Open X2; line L11 with Open X1

**Expected result:** No X3 is added to L6. L6 shows once in the queue, with X2, and the X2 priority changes to High. No X2 is added to L11. L11 shows once in the queue, with X1.

### TC-10e

**Unassigned High exception is escalated to the Team Lead**

User story: US-10 · Priority: P1 · Release: R1

**Preconditions:** Exception E1 is High and has been Open with no owner for 3 working hours. Exception E2 is High and has been Open with no owner for 1 working hour.

**Steps:**

1. Start the hourly check by hand.
2. Log in as Team Lead and check notifications.

**Test data:** Exceptions E1 and E2

**Expected result:** The Team Lead gets a notification for E1, with the line and the reason. There is no notification for E2. Both exceptions stay Open in the queue.

### TC-11a

**Change or cancel before production**

User story: US-11 · Priority: P1 · Release: R3

**Preconditions:** Lines A and B are Sent to supplier (not In production). Line B has an Open X3.

**Steps:**

1. As CS, log a change request for line A (new personalization text) (X5).
2. Update line A and send the change to the supplier.
3. Log a cancel request for line B (X5) and cancel it at the supplier.
4. The supplier confirms both.
5. Close both X5 exceptions, recording the supplier's confirmation.
6. Start the hourly check by hand and open the queue.

**Test data:** Two lines not in production; line B has an Open X3

**Expected result:** Line A has the new personalization. Line B becomes Canceled and its open X3 is closed. Both X5 exceptions are Resolved, each with the supplier's confirmation recorded. Step 6: line B is excluded from the hourly check and is not in the queue (FRD §5.3).

### TC-11b

**Change or cancel after production starts (negative)**

User story: US-11 · Priority: P1 · Release: R3

**Preconditions:** Line C is In production

**Steps:**

1. As CS, log a change request for line C (X5).
2. Try to edit the personalization.
3. Try to cancel the line.
4. Tell the customer and close X5 with an answer note.

**Test data:** Line in production

**Expected result:** Steps 2 and 3 are blocked (BUS-01). X5 closes only with an answer note.

### TC-12a

**One order, two suppliers: first tracking goes to Etsy, later tracking stays in Lark**

User story: US-12 · Priority: P1 · Release: R1

**Preconditions:** Etsy order 10482 has two lines: Line 1 with Supplier 1 and Line 2 with Supplier 2. Both are In production. No tracking is on Etsy yet.

**Steps:**

1. In the Supplier 2 test system, ship Line 2 with Tracking B.
2. Let the sync run and open the order in the Etsy test shop.
3. In the Supplier 1 test system, ship Line 1 with Tracking A.
4. Let the sync run and open the Etsy order again.
5. As CS, search for Etsy Order ID 10482 in Lark.

**Test data:** Order 10482 (2 lines), Tracking A and B

**Expected result:** Step 2: Tracking B is on the Etsy order, and the order is completed on Etsy under the shop rule. Step 4: Etsy still shows only Tracking B; Tracking A is saved on Line 1 in Lark and no X6 is raised. Step 5: both lines are listed, each with its own supplier, status and tracking number.

### TC-12b

**[Technical check] Tracking sync fails (negative)**

User story: US-12 · Priority: P1 · Release: R1

**Preconditions:** Etsy API is not available (simulated)

**Steps:**

1. Ship a line that carries the first tracking number of its Etsy order.
2. Let the sync run.
3. As CS, open the queue.
4. Add the tracking number in the Etsy test shop by hand, confirm it is on the Etsy order, and resolve X6.

**Test data:** Simulated Etsy outage

**Expected result:** The line has X6. The failure is logged. Step 4: after confirming the tracking number is on the Etsy order, CS resolves X6 and it leaves the queue.

### TC-13a

**Operational dashboard**

User story: US-13 · Priority: P2 · Release: R3 (issue rate: R4)

**Preconditions:** Test orders, exceptions and cases exist

**Steps:**

1. Log in as Team Lead and open the dashboard.
2. Do the same as a Management user, then try to open the order lines.
3. Change one line status in Lark and wait up to 15 minutes.
4. Send a status update from the Supplier 1 test system and open the dashboard again.

**Test data:** Mixed test data; Supplier 1 test system

**Expected result:** Both users see the 5 required figures (issue rate from R4). The Management user can open only the dashboard. After step 3, figures from Lark data are updated within 15 minutes. After step 4, figures that use Supplier 1 status data reflect the update.

### TC-14a

**A case needs a cause (negative)**

User story: US-14 · Priority: P1 · Release: R4

**Preconditions:** A delivered line exists

**Steps:**

1. As CS, create a case for a wrong print.
2. Save it without a cause.

**Test data:** Delivered line

**Expected result:** Saving is blocked. A message asks for the cause.

### TC-14b

**Case routing by cause; case history is saved**

User story: US-14 · Priority: P1 · Release: R4

**Preconditions:** 3 delivered lines exist

**Steps:**

1. Create 3 cases with causes Design, Supplier and Customer.
2. Check the owner and supplier link of each case.
3. Close the Customer case with a result.
4. Open the Status History of the Customer case.

**Test data:** 3 cases

**Expected result:** The Design case is assigned to a Designer. The Supplier case is linked to the supplier, and CS records the communication and result. The Customer case stays with CS. Each case shows when it was opened. Step 4: the history shows the new case (Open) and the change Open → Closed, each with the time and who made it (the CS user) (NFR-03). Each case also shows on its linked order line.

### TC-15a

**Record refund or replacement**

User story: US-15 · Priority: P1 · Release: R4

**Preconditions:** Case A and case B are Supplier cases

**Steps:**

1. On case A, record "Refund".
2. On case B, record "Replacement".
3. Open the new line for case B.

**Test data:** Two Supplier cases

**Expected result:** Case A shows the refund choice. Case B gets a new order line linked to the case; the line gets its preferred supplier from the mapping (FR-04) and goes through the order check (FR-06).

### TC-15b

**Replacement blocked before design approval; artwork linked after approval (negative)**

User story: US-15 · Priority: P1 · Release: R4

**Preconditions:** Design case on a line for SKU-A (MUG-11OZ, mapped to Supplier 1) where the design was changed. The Designer has prepared replacement artwork. No customer approval is recorded.

**Steps:**

1. As CS, try to create the replacement.
2. Record the customer's approval.
3. Create the replacement.
4. As the Designer, attach the approved replacement artwork to the new line.
5. Let the send step run and check the Supplier 1 test system.

**Test data:** Design case with a changed design, replacement artwork file

**Expected result:** Step 1 is blocked (BUS-02). Step 3 creates the replacement line, linked to the case; it gets Supplier 1 as preferred supplier from the mapping and is not sent while the artwork is missing (X1). Step 4: the line passes the check and moves to Ready to send. Step 5: Supplier 1 receives the line with the replacement artwork.

### TC-16a

**Designer sees only assigned design cases and attaches replacement artwork**

User story: US-16, US-02 · Priority: P1 · Release: R4

**Preconditions:** Design case D1 is assigned to Designer 1; the customer's approval is recorded and its replacement line exists. Design case D2 is assigned to another Designer. A Supplier case also exists.

**Steps:**

1. Log in as Designer 1 and open the issue cases.
2. Try to open the exception queue and the Supplier Mapping.
3. Open the replacement line of D1 and attach the approved artwork file.
4. Log in as CS and open that line.

**Test data:** Design cases D1 and D2, artwork file

**Expected result:** Step 1: only D1 is listed, with its order line details. Step 2: neither is available to the Designer. Step 3: the file is saved on the replacement line. Step 4: CS sees the file on the line.

---

[← User Stories](04-user-stories.md) · [README](../README.md) · [RTM →](06-rtm.md)
