'
Problem
You are a data engineer at a public library system. Design a relational schema to manage books, members, and borrowing records.

Business Context
A library needs to track their collection of books, registered members, and lending activities. The system must answer key business questions:

How many books does each member currently have borrowed?
Which books are overdue?
What is the most popular book by borrowing count?
How many active members do we have?
Which books need to be reordered (low stock)?
Requirements
Design tables to store books with author information
Manage member profiles and membership status
Track borrowing history with due dates and return dates
Support querying overdue books
Enable reporting on popular books and member borrowing patterns
Constraints
Small library: ~10,000 books, ~5,000 members, ~50,000 borrowing records
Single library location
Standard SQL database (PostgreSQL or MySQL)
Data retention: 5 years of borrowing history

'

CREATE TABLE "Books" (
	"book_id" UUID NOT NULL UNIQUE,
	"number_of_copies_in_total" INTEGER NOT NULL,
	"title" VARCHAR(255) NOT NULL,
	"isbn" VARCHAR(255) NOT NULL UNIQUE,
	"genre" VARCHAR(255) NOT NULL,
	"publication_year" DATE NOT NULL,
	"number_of_copies_available" INTEGER NOT NULL,
	PRIMARY KEY("book_id")
);

CREATE TABLE "Members" (
	"member_id" UUID NOT NULL UNIQUE,
	"member_phone_number" VARCHAR(255) NOT NULL,
	"active_member" BOOLEAN NOT NULL,
	"active_fine" DOUBLE PRECISION,
	"member_address" VARCHAR(255) NOT NULL,
	"member_secondary_phone_number" VARCHAR(255),
	"member_first_name" VARCHAR(255) NOT NULL,
	"member_last_name" VARCHAR(255) NOT NULL,
	"email" VARCHAR(255) NOT NULL UNIQUE,
	PRIMARY KEY("member_id")
);

CREATE TABLE "Borrowing" (
	"borrowing_transaction_id" UUID NOT NULL UNIQUE,
	"book_id" UUID NOT NULL,
	"member_id" UUID NOT NULL,
	"return_date" TIMESTAMP,
	"due_date" TIMESTAMP NOT NULL,
	PRIMARY KEY("borrowing_transaction_id")
);

CREATE TABLE "Authors" (
	"author_id" UUID NOT NULL UNIQUE,
	"author_first_name" VARCHAR(255) NOT NULL,
	"author_last_name" VARCHAR(255) NOT NULL,
	PRIMARY KEY("author_id")
);

CREATE TABLE "books_and_authors_junction_table" (
	"id" INTEGER NOT NULL UNIQUE,
	"author_id" UUID NOT NULL,
	"book_id" UUID NOT NULL,
	PRIMARY KEY("id")
);

ALTER TABLE "Borrowing"
ADD FOREIGN KEY("book_id") REFERENCES "Books"("book_id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "Borrowing"
ADD FOREIGN KEY("member_id") REFERENCES "Members"("member_id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "books_and_authors_junction_table"
ADD FOREIGN KEY("id") REFERENCES "Authors"("author_id")
ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE "books_and_authors_junction_table"
ADD FOREIGN KEY("book_id") REFERENCES "Books"("book_id")
ON UPDATE NO ACTION ON DELETE CASCADE;

-- Indexes on foreign key columns
CREATE INDEX "idx_borrowing_book_id" ON "Borrowing"("book_id");
CREATE INDEX "idx_borrowing_member_id" ON "Borrowing"("member_id");
CREATE INDEX "idx_books_and_authors_junction_table_book_id" ON "books_and_authors_junction_table"("book_id");