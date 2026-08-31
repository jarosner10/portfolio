--DROP TABLES

DROP TABLE emppayroll CASCADE CONSTRAINTS;
DROP TABLE payments CASCADE CONSTRAINTS;
DROP TABLE tickets CASCADE CONSTRAINTS;
DROP TABLE shifts CASCADE CONSTRAINTS;
DROP TABLE orders CASCADE CONSTRAINTS;
DROP TABLE events CASCADE CONSTRAINTS;
DROP TABLE artists CASCADE CONSTRAINTS;
DROP TABLE customers CASCADE CONSTRAINTS;
DROP TABLE employees CASCADE CONSTRAINTS;
DROP TABLE venue CASCADE CONSTRAINTS;

-- CREATE TABLES

-- 1. Artists Table
CREATE TABLE artists (
    artistid NUMBER(8) NOT NULL,
    name     VARCHAR2(100) NOT NULL,
    genre    VARCHAR2(150) NOT NULL,
    CONSTRAINT artists_pk PRIMARY KEY (artistid)
);

-- 2. Venue Table
CREATE TABLE venue (
    venueid NUMBER(8) NOT NULL,
    city    VARCHAR2(150) NOT NULL,
    state   VARCHAR2(50),
    type    VARCHAR2(100) NOT NULL,
    CONSTRAINT venue_pk PRIMARY KEY (venueid)
);

-- 3. Customers Table
CREATE TABLE customers (
    customerid NUMBER(8) NOT NULL,
    name       VARCHAR2(100),
    type       VARCHAR2(100),
    email      VARCHAR2(100) NOT NULL,
    phone      VARCHAR2(20),
    address    VARCHAR2(150),
    CONSTRAINT customers_pk PRIMARY KEY (customerid)
);

-- 4. Employees Table
CREATE TABLE employees (
    empid  NUMBER(8) NOT NULL,
    name   VARCHAR2(100) NOT NULL,
    dept   VARCHAR2(100),
    salary NUMBER(10, 2) NOT NULL,
    CONSTRAINT employees_pk PRIMARY KEY (empid)
);

-- 5. EmpPayroll Table
CREATE TABLE emppayroll (
    emppayrollid NUMBER(8) NOT NULL,
    empid        NUMBER(8) NOT NULL,
    hoursworked  NUMBER(8, 2) NOT NULL,
    hourlyrate   NUMBER(8, 2) NOT NULL,
    amtpaid      NUMBER(10, 2) NOT NULL,
    CONSTRAINT emppayroll_pk PRIMARY KEY (emppayrollid)
);

-- 6. Events Table
CREATE TABLE events (
    eventid     NUMBER(8) NOT NULL,
    type        VARCHAR2(100),
    event_date  DATE NOT NULL, 
    description VARCHAR2(1000),
    artistid    NUMBER(8) NOT NULL,
    venueid     NUMBER(8) NOT NULL, 
    CONSTRAINT events_pk PRIMARY KEY (eventid)
);

-- 7. Orders Table
CREATE TABLE orders (
    orderid    NUMBER(8) NOT NULL,
    order_date DATE, 
    shipdate   DATE,
    eventid    NUMBER(8) NOT NULL,
    customerid NUMBER(8) NOT NULL,
    CONSTRAINT orders_pk PRIMARY KEY (orderid)
);

-- 8. Payments Table
CREATE TABLE payments (
    paymentid NUMBER(8) NOT NULL,
    orderid   NUMBER(8) NOT NULL,
    pmtamount NUMBER (10,2) NOT NULL,
    CONSTRAINT payments_pk PRIMARY KEY (paymentid)
);

-- 9. Shifts Table
CREATE TABLE shifts (
    empid   NUMBER(8) NOT NULL,
    eventid NUMBER(8) NOT NULL,
    duration NUMBER (8,2),
    CONSTRAINT shifts_pk PRIMARY KEY (empid, eventid)
);

-- 10. Tickets Table
CREATE TABLE tickets (
    ticketid NUMBER(8) NOT NULL,
    orderid  NUMBER(8),
    type     VARCHAR2(100),
    eventid  NUMBER(8) NOT NULL,
    CONSTRAINT tickets_pk PRIMARY KEY (ticketid)
);

ALTER TABLE emppayroll
    ADD CONSTRAINT emppayroll_employees_fk FOREIGN KEY (empid)
        REFERENCES employees (empid);

ALTER TABLE events
    ADD CONSTRAINT events_artists_fk FOREIGN KEY (artistid)
        REFERENCES artists (artistid);

ALTER TABLE events
    ADD CONSTRAINT events_venue_fk FOREIGN KEY (venueid)
        REFERENCES venue (venueid);

ALTER TABLE orders
    ADD CONSTRAINT orders_customers_fk FOREIGN KEY (customerid)
        REFERENCES customers (customerid);

ALTER TABLE orders
    ADD CONSTRAINT orders_events_fk FOREIGN KEY (eventid)
        REFERENCES events (eventid);

ALTER TABLE payments
    ADD CONSTRAINT payments_orders_fk FOREIGN KEY (orderid)
        REFERENCES orders (orderid);

ALTER TABLE shifts
    ADD CONSTRAINT shifts_employees_fk FOREIGN KEY (empid)
        REFERENCES employees (empid);

ALTER TABLE shifts
    ADD CONSTRAINT shifts_events_fk FOREIGN KEY (eventid)
        REFERENCES events (eventid);

ALTER TABLE tickets
    ADD CONSTRAINT tickets_events_fk FOREIGN KEY (eventid)
        REFERENCES events (eventid);

ALTER TABLE tickets
    ADD CONSTRAINT tickets_orders_fk FOREIGN KEY (orderid)
        REFERENCES orders (orderid);
        
CREATE OR REPLACE TRIGGER trg_assign_ticket
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    -- Update a single available ticket for the requested event
    UPDATE tickets
    SET orderid = :NEW.orderid
    WHERE ticketid = (
        -- Subquery to find the first available ticket ID for this event
        SELECT MIN(ticketid) 
        FROM tickets 
        WHERE eventid = :NEW.eventid 
          AND orderid IS NULL
    );
END;
/


-- ==========================================
-- 1. POPULATE ARTISTS (15 Records)
-- ==========================================
INSERT INTO artists (artistid, name, genre) VALUES (1, 'The Midnight Echo', 'Indie Rock');
INSERT INTO artists (artistid, name, genre) VALUES (2, 'Synthwave Dreams', 'Electronic');
INSERT INTO artists (artistid, name, genre) VALUES (3, 'Sarah Jenkins', 'Folk');
INSERT INTO artists (artistid, name, genre) VALUES (4, 'Velvet Underground Cover', 'Rock');
INSERT INTO artists (artistid, name, genre) VALUES (5, 'DJ Quantum', 'EDM');
INSERT INTO artists (artistid, name, genre) VALUES (6, 'Blue Note Quartet', 'Jazz');
INSERT INTO artists (artistid, name, genre) VALUES (7, 'Steel Panther', 'Heavy Metal');
INSERT INTO artists (artistid, name, genre) VALUES (8, 'Luna and The Whalers', 'Pop');
INSERT INTO artists (artistid, name, genre) VALUES (9, 'Cactus Jack', 'Country');
INSERT INTO artists (artistid, name, genre) VALUES (10, 'Neon Skyline', 'Synth-Pop');
INSERT INTO artists (artistid, name, genre) VALUES (11, 'The Crimson Tide', 'Punk');
INSERT INTO artists (artistid, name, genre) VALUES (12, 'Orchestral Maneuvers', 'Classical');
INSERT INTO artists (artistid, name, genre) VALUES (13, 'River City Beats', 'Hip Hop');
INSERT INTO artists (artistid, name, genre) VALUES (14, 'Misty Mountains', 'Bluegrass');
INSERT INTO artists (artistid, name, genre) VALUES (15, 'Solar Flare', 'Alternative');

-- ==========================================
-- 2. POPULATE VENUE (10 Records)
-- ==========================================
INSERT INTO venue (venueid, city, state, type) VALUES (101, 'Austin', 'TX', 'Amphitheater');
INSERT INTO venue (venueid, city, state, type) VALUES (102, 'Nashville', 'TN', 'Club');
INSERT INTO venue (venueid, city, state, type) VALUES (103, 'New York', 'NY', 'Arena');
INSERT INTO venue (venueid, city, state, type) VALUES (104, 'Chicago', 'IL', 'Theater');
INSERT INTO venue (venueid, city, state, type) VALUES (105, 'Seattle', 'WA', 'Outdoors');
INSERT INTO venue (venueid, city, state, type) VALUES (106, 'Denver', 'CO', 'Ballroom');
INSERT INTO venue (venueid, city, state, type) VALUES (107, 'Miami', 'FL', 'Beach Club');
INSERT INTO venue (venueid, city, state, type) VALUES (108, 'San Francisco', 'CA', 'Hall');
INSERT INTO venue (venueid, city, state, type) VALUES (109, 'Atlanta', 'GA', 'Stadium');
INSERT INTO venue (venueid, city, state, type) VALUES (110, 'Boston', 'MA', 'Opera House');

-- ==========================================
-- 3. POPULATE CUSTOMERS (30 Records)
-- ==========================================
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (201, 'Alice Thompson', 'VIP', 'alice.t@gmail.com', '555-0101', '123 Maple St');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (202, 'Bob Richards', 'Regular', 'bob.r@yahoo.com', '555-0102', '456 Oak Ave');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (203, 'Charlie Davis', 'Regular', 'charlie.d@outlook.com', '555-0103', '789 Pine Rd');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (204, 'Diana Prince', 'VIP', 'diana.p@gmail.com', '555-0104', '101 Amazon Way');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (205, 'Edward Norton', 'Student', 'ed.n@edu.com', '555-0105', '202 College Ln');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (206, 'Fiona Glenanne', 'Regular', 'fiona.g@cia.gov', '555-0106', '303 Burn St');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (207, 'George Costanza', 'Regular', 'george.c@vandelay.com', '555-0107', '404 Queens Blvd');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (208, 'Hannah Abbott', 'Student', 'hannah.a@hogwarts.uk', '555-0108', '505 Hufflepuff Rd');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (209, 'Ian Wright', 'Regular', 'ian.w@arsenal.com', '555-0109', '606 Highbury Ave');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (210, 'Julia Roberts', 'VIP', 'julia.r@hollywood.com', '555-0110', '707 Rodeo Dr');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (211, 'Kevin Hart', 'Regular', 'kevin.h@comedy.com', '555-0111', '808 Laugh Ln');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (212, 'Laura Palmer', 'Regular', 'laura.p@twinpeaks.com', '555-0112', '705 Pine St');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (213, 'Michael Scott', 'Regular', 'm.scott@dundermifflin.com', '555-0113', '1725 Slough Ave');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (214, 'Nancy Drew', 'Student', 'n.drew@mysteries.com', '555-0114', '221 River St');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (215, 'Oscar Martinez', 'Regular', 'o.martinez@accounting.com', '555-0115', '120 Paper Way');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (216, 'Peter Parker', 'Student', 'p.parker@dailybugle.com', '555-0116', '20 Ingram St');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (217, 'Quentin Smith', 'Regular', 'q.smith@dreamer.com', '555-0117', '1428 Elm St');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (218, 'Rachel Green', 'Regular', 'r.green@centralperk.com', '555-0118', '90 Bedford St');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (219, 'Steve Rogers', 'VIP', 's.rogers@avengers.org', '555-0119', '569 Lefferts Ave');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (220, 'Tony Stark', 'VIP', 't.stark@starkintl.com', '555-0120', '10880 Malibu Rd');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (221, 'Ursula Buffay', 'Regular', 'u.buffay@waitress.com', '555-0121', '455 West 11th St');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (222, 'Victor Von Doom', 'VIP', 'v.doom@latveria.gov', '555-0122', '1 Castle Dr');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (223, 'Wanda Maximoff', 'Regular', 'w.maximoff@chaos.com', '555-0123', '2800 Sherwood Dr');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (224, 'Xavier Charles', 'VIP', 'professor.x@mansion.edu', '555-0124', '1407 Graymalkin Ln');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (225, 'Yvonne Strahovski', 'Regular', 'yvonne.s@agent.com', '555-0125', '999 Secret Ave');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (226, 'Zane Grey', 'Regular', 'z.grey@west.com', '555-0126', '12 Cowboy Way');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (227, 'Aaron Burr', 'VIP', 'a.burr@hamilton.com', '555-0127', '18 Maiden Ln');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (228, 'Betty Cooper', 'Student', 'b.cooper@riverdale.com', '555-0128', '123 Elm St');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (229, 'Clark Kent', 'Regular', 'c.kent@dailyplanet.com', '555-0129', '344 Clinton St');
INSERT INTO customers (customerid, name, type, email, phone, address) VALUES (230, 'Zoe Saldana', 'VIP', 'zoe.s@space.com', '555-0130', '909 Star Way');
-- ==========================================
-- 4. POPULATE EMPLOYEES (12 Records)
-- ==========================================
INSERT INTO employees (empid, name, dept, salary) VALUES (501, 'John Smith', 'Management', 75000.00);
INSERT INTO employees (empid, name, dept, salary) VALUES (502, 'Jane Doe', 'Operations', 55000.00);
INSERT INTO employees (empid, name, dept, salary) VALUES (503, 'Mike Miller', 'Security', 45000.00);
INSERT INTO employees (empid, name, dept, salary) VALUES (504, 'Sarah Wilson', 'Ticketing', 42000.00);
INSERT INTO employees (empid, name, dept, salary) VALUES (505, 'Tom Brown', 'Operations', 52000.00);
INSERT INTO employees (empid, name, dept, salary) VALUES (506, 'Emily Davis', 'Marketing', 60000.00);
INSERT INTO employees (empid, name, dept, salary) VALUES (507, 'Chris Evans', 'Security', 46000.00);
INSERT INTO employees (empid, name, dept, salary) VALUES (508, 'Anna Kendrick', 'Ticketing', 41000.00);
INSERT INTO employees (empid, name, dept, salary) VALUES (509, 'Robert Downey', 'Management', 90000.00);
INSERT INTO employees (empid, name, dept, salary) VALUES (510, 'Scarlett J', 'Marketing', 62000.00);
INSERT INTO employees (empid, name, dept, salary) VALUES (511, 'Mark Ruffalo', 'Operations', 54000.00);
INSERT INTO employees (empid, name, dept, salary) VALUES (512, 'Jeremy Renner', 'Security', 47000.00);

-- ==========================================
-- 5. POPULATE EMPPAYROLL (12 Records)
-- ==========================================
INSERT INTO emppayroll (emppayrollid, empid, hoursworked, hourlyrate, amtpaid) VALUES (1, 501, 40, 36.00, 1440.00);
INSERT INTO emppayroll (emppayrollid, empid, hoursworked, hourlyrate, amtpaid) VALUES (2, 502, 40, 26.50, 1060.00);
INSERT INTO emppayroll (emppayrollid, empid, hoursworked, hourlyrate, amtpaid) VALUES (3, 503, 45, 20.00, 950.00);
INSERT INTO emppayroll (emppayrollid, empid, hoursworked, hourlyrate, amtpaid) VALUES (4, 504, 38, 20.00, 760.00);
INSERT INTO emppayroll (emppayrollid, empid, hoursworked, hourlyrate, amtpaid) VALUES (5, 505, 40, 25.00, 1000.00);
INSERT INTO emppayroll (emppayrollid, empid, hoursworked, hourlyrate, amtpaid) VALUES (6, 506, 40, 28.80, 1152.00);
INSERT INTO emppayroll (emppayrollid, empid, hoursworked, hourlyrate, amtpaid) VALUES (7, 507, 50, 21.00, 1155.00);
INSERT INTO emppayroll (emppayrollid, empid, hoursworked, hourlyrate, amtpaid) VALUES (8, 508, 30, 20.00, 600.00);
INSERT INTO emppayroll (emppayrollid, empid, hoursworked, hourlyrate, amtpaid) VALUES (9, 509, 40, 43.00, 1720.00);
INSERT INTO emppayroll (emppayrollid, empid, hoursworked, hourlyrate, amtpaid) VALUES (10, 510, 40, 29.80, 1192.00);
INSERT INTO emppayroll (emppayrollid, empid, hoursworked, hourlyrate, amtpaid) VALUES (11, 511, 40, 26.00, 1040.00);
INSERT INTO emppayroll (emppayrollid, empid, hoursworked, hourlyrate, amtpaid) VALUES (12, 512, 42, 22.50, 990.00);

-- ==========================================
-- 6. POPULATE EVENTS (10 Records)
-- ==========================================
INSERT INTO events (eventid, type, event_date, description, artistid, venueid) VALUES (301, 'Concert', TO_DATE('2026-05-15','YYYY-MM-DD'), 'Summer Kickoff', 1, 101);
INSERT INTO events (eventid, type, event_date, description, artistid, venueid) VALUES (302, 'Live Recording', TO_DATE('2026-05-20','YYYY-MM-DD'), 'Live at Nashville', 2, 102);
INSERT INTO events (eventid, type, event_date, description, artistid, venueid) VALUES (303, 'Festival', TO_DATE('2026-06-01','YYYY-MM-DD'), 'The Big Apple Fest', 3, 103);
INSERT INTO events (eventid, type, event_date, description, artistid, venueid) VALUES (304, 'Charity', TO_DATE('2026-06-10','YYYY-MM-DD'), 'Acoustic Night', 4, 104);
INSERT INTO events (eventid, type, event_date, description, artistid, venueid) VALUES (305, 'Concert', TO_DATE('2026-06-15','YYYY-MM-DD'), 'Neon Nights', 5, 105);
INSERT INTO events (eventid, type, event_date, description, artistid, venueid) VALUES (306, 'Gala', TO_DATE('2026-07-04','YYYY-MM-DD'), 'Independence Jazz', 6, 106);
INSERT INTO events (eventid, type, event_date, description, artistid, venueid) VALUES (307, 'Concert', TO_DATE('2026-07-12','YYYY-MM-DD'), 'Metal Mania', 7, 107);
INSERT INTO events (eventid, type, event_date, description, artistid, venueid) VALUES (308, 'Concert', TO_DATE('2026-07-20','YYYY-MM-DD'), 'Pop Princess Tour', 8, 108);
INSERT INTO events (eventid, type, event_date, description, artistid, venueid) VALUES (309, 'Festival', TO_DATE('2026-08-05','YYYY-MM-DD'), 'Country Roots', 9, 109);
INSERT INTO events (eventid, type, event_date, description, artistid, venueid) VALUES (310, 'Opera', TO_DATE('2026-08-15','YYYY-MM-DD'), 'Modern Synth Opera', 10, 110);

-- ==========================================
-- 7. POPULATE ORDERS (25 Records)
-- ==========================================
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (401, TO_DATE('2026-04-01','YYYY-MM-DD'), TO_DATE('2026-04-05','YYYY-MM-DD'), 301, 201);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (402, TO_DATE('2026-04-02','YYYY-MM-DD'), TO_DATE('2026-04-06','YYYY-MM-DD'), 301, 202);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (403, TO_DATE('2026-04-05','YYYY-MM-DD'), TO_DATE('2026-04-10','YYYY-MM-DD'), 302, 203);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (404, TO_DATE('2026-04-10','YYYY-MM-DD'), NULL, 303, 204);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (405, TO_DATE('2026-04-12','YYYY-MM-DD'), TO_DATE('2026-04-15','YYYY-MM-DD'), 303, 205);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (406, TO_DATE('2026-04-15','YYYY-MM-DD'), TO_DATE('2026-04-20','YYYY-MM-DD'), 304, 206);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (407, TO_DATE('2026-04-18','YYYY-MM-DD'), TO_DATE('2026-04-22','YYYY-MM-DD'), 304, 207);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (408, TO_DATE('2026-04-20','YYYY-MM-DD'), NULL, 305, 208);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (409, TO_DATE('2026-04-22','YYYY-MM-DD'), TO_DATE('2026-04-28','YYYY-MM-DD'), 305, 209);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (410, TO_DATE('2026-04-25','YYYY-MM-DD'), TO_DATE('2026-04-30','YYYY-MM-DD'), 306, 210);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (411, TO_DATE('2026-04-28','YYYY-MM-DD'), TO_DATE('2026-05-02','YYYY-MM-DD'), 306, 211);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (412, TO_DATE('2026-05-01','YYYY-MM-DD'), NULL, 307, 212);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (413, TO_DATE('2026-05-03','YYYY-MM-DD'), TO_DATE('2026-05-08','YYYY-MM-DD'), 307, 213);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (414, TO_DATE('2026-05-05','YYYY-MM-DD'), TO_DATE('2026-05-10','YYYY-MM-DD'), 308, 214);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (415, TO_DATE('2026-05-07','YYYY-MM-DD'), TO_DATE('2026-05-12','YYYY-MM-DD'), 308, 215);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (416, TO_DATE('2026-05-10','YYYY-MM-DD'), NULL, 309, 216);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (417, TO_DATE('2026-05-12','YYYY-MM-DD'), TO_DATE('2026-05-17','YYYY-MM-DD'), 309, 217);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (418, TO_DATE('2026-05-15','YYYY-MM-DD'), TO_DATE('2026-05-20','YYYY-MM-DD'), 310, 218);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (419, TO_DATE('2026-05-18','YYYY-MM-DD'), TO_DATE('2026-05-23','YYYY-MM-DD'), 301, 219);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (420, TO_DATE('2026-05-20','YYYY-MM-DD'), NULL, 302, 220);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (421, TO_DATE('2026-05-22','YYYY-MM-DD'), TO_DATE('2026-05-27','YYYY-MM-DD'), 303, 221);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (422, TO_DATE('2026-05-25','YYYY-MM-DD'), TO_DATE('2026-05-30','YYYY-MM-DD'), 304, 222);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (423, TO_DATE('2026-05-28','YYYY-MM-DD'), TO_DATE('2026-06-02','YYYY-MM-DD'), 305, 223);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (424, TO_DATE('2026-05-30','YYYY-MM-DD'), NULL, 306, 224);
INSERT INTO orders (orderid, order_date, shipdate, eventid, customerid) VALUES (425, TO_DATE('2026-06-01','YYYY-MM-DD'), TO_DATE('2026-06-05','YYYY-MM-DD'), 310, 230);

-- ==========================================
-- 8. POPULATE TICKETS (50 Records)
-- ==========================================
-- Tickets assigned to Orders (first 40)
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1001, 401, 'VIP', 301);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1002, 401, 'VIP', 301);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1003, 402, 'GA', 301);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1004, 403, 'GA', 302);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1005, 404, 'Premium', 303);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1006, 405, 'GA', 303);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1007, 406, 'GA', 304);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1008, 407, 'GA', 304);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1009, 408, 'VIP', 305);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1010, 409, 'GA', 305);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1011, 410, 'VIP', 306);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1012, 411, 'GA', 306);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1013, 412, 'GA', 307);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1014, 413, 'GA', 307);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1015, 414, 'GA', 308);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1016, 415, 'GA', 308);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1017, 416, 'VIP', 309);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1018, 417, 'GA', 309);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1019, 418, 'Premium', 310);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1020, 419, 'VIP', 301);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1021, 420, 'GA', 302);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1022, 421, 'GA', 303);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1023, 422, 'GA', 304);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1024, 423, 'GA', 305);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1025, 424, 'GA', 306);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1026, 425, 'Premium', 310);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1027, 401, 'GA', 301);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1028, 402, 'GA', 301);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1029, 403, 'GA', 302);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1030, 404, 'GA', 303);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1031, 405, 'GA', 303);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1032, 406, 'GA', 304);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1033, 407, 'GA', 304);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1034, 408, 'GA', 305);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1035, 409, 'GA', 305);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1036, 410, 'GA', 306);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1037, 411, 'GA', 306);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1038, 412, 'GA', 307);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1039, 413, 'GA', 307);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1040, 414, 'GA', 308);

-- Unsold Inventory (Order ID is NULL)
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1041, NULL, 'GA', 301);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1042, NULL, 'VIP', 302);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1043, NULL, 'GA', 303);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1044, NULL, 'Premium', 304);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1045, NULL, 'GA', 301);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1046, NULL, 'VIP', 302);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1047, NULL, 'GA', 309);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1048, NULL, 'GA', 310);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1049, NULL, 'Premium', 310);
INSERT INTO tickets (ticketid, orderid, type, eventid) VALUES (1050, NULL, 'GA', 310);

-- ==========================================
-- 9. POPULATE PAYMENTS (25 Records)
-- ==========================================
-- One payment for each order
INSERT INTO payments (paymentid, orderid) VALUES (601, 401);
INSERT INTO payments (paymentid, orderid) VALUES (602, 402);
INSERT INTO payments (paymentid, orderid) VALUES (603, 403);
INSERT INTO payments (paymentid, orderid) VALUES (604, 404);
INSERT INTO payments (paymentid, orderid) VALUES (605, 405);
-- ... [One-to-one mapping for all 25 orders]
INSERT INTO payments (paymentid, orderid) VALUES (625, 425);

-- ==========================================
-- 10. POPULATE SHIFTS (20 Records)
-- ==========================================
-- Assigning employees to multiple events
INSERT INTO shifts (empid, eventid) VALUES (502, 301);
INSERT INTO shifts (empid, eventid) VALUES (503, 301);
INSERT INTO shifts (empid, eventid) VALUES (507, 301);
INSERT INTO shifts (empid, eventid) VALUES (512, 301);
INSERT INTO shifts (empid, eventid) VALUES (502, 302);
INSERT INTO shifts (empid, eventid) VALUES (503, 302);
INSERT INTO shifts (empid, eventid) VALUES (504, 303);
INSERT INTO shifts (empid, eventid) VALUES (505, 304);
INSERT INTO shifts (empid, eventid) VALUES (506, 305);
INSERT INTO shifts (empid, eventid) VALUES (507, 306);
INSERT INTO shifts (empid, eventid) VALUES (511, 307);
INSERT INTO shifts (empid, eventid) VALUES (512, 308);
INSERT INTO shifts (empid, eventid) VALUES (501, 309);
INSERT INTO shifts (empid, eventid) VALUES (509, 310);
-- Adding double shifts for some
INSERT INTO shifts (empid, eventid) VALUES (502, 303);
INSERT INTO shifts (empid, eventid) VALUES (503, 303);
INSERT INTO shifts (empid, eventid) VALUES (511, 301);
INSERT INTO shifts (empid, eventid) VALUES (504, 305);
INSERT INTO shifts (empid, eventid) VALUES (508, 301);
INSERT INTO shifts (empid, eventid) VALUES (508, 302);

COMMIT;