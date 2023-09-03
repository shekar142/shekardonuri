create database library1;
use library1;
create table tbl_library_branch(
library_branch_BranchID int primary key auto_increment,
library_branch_BranchName varchar(50),
library_branch_BranchAddress varchar(50));
select * from tbl_library_branch;

create table tbl_library_borrower(
borrower_CardNo int primary key auto_increment,
borrower_BorrowerName varchar(50) not null,
borrower_BorrowerAddress varchar(50) not null,
borrower_BorrowerPhone varchar(25));

create table tbl_publisher(
publisher_PublisherName varchar(50) primary key,
publisher_PublisherAddress varchar(50),
publisher_PublisherPhone varchar(25));


create table tbl_book(
book_BookID int primary key auto_increment,
book_Title varchar(50) not null,
book_PublisherName varchar(50) not null,
foreign key (book_PublisherName)
references tbl_publisher(publisher_publisherName));
describe tbl_book_authors;

create table tbl_book_authors(
book_authors_AuthorID int primary key auto_increment,
book_authors_BookID int,
book_authors_AuthorName varchar(50) not null,
foreign key (book_authors_BookID)
references tbl_book(book_BookID));

create table tbl_book_copies(
book_copies_CopiesID int primary key auto_increment,
book_copies_BookID int,
book_copies_BranchID int,
book_copies_No_Of_Copies int,
foreign key (book_copies_BookID)
references tbl_book(book_BookID) on update cascade,
foreign key (book_copies_BranchID)
references tbl_library_branch(library_branch_BranchID) on update cascade);

drop table tbl_book_loans;
create table tbl_book_loans(
book_loans_LoansID int primary key auto_increment,
book_loans_BookID int,
book_loans_BranchID int,
book_loans_CardNo  int,
book_loans_DateOut date,
book_loans_DueDate date,
foreign key (book_loans_BookID)
references tbl_book(book_BookID)on update cascade,
foreign key (book_loans_BranchID)
references tbl_library_branch(library_branch_BranchID)on update cascade,
foreign key (book_loans_CardNo)
references tbl_library_borrower(borrower_CardNo)on update cascade);

select * from tbl_library_branch;
select * from tbl_book;
select * from tbl_book_copies;
select * from tbl_library_borrower;
select * from tbl_publisher;
select * from tbl_book_authors;
select * from tbl_book_loans;


-- How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
with cte1 as
(select b.book_Title,c.book_copies_BranchID,c.book_copies_No_Of_Copies
from tbl_book as b
join tbl_book_copies as c
on b.book_BookID= c.book_copies_BookID),
cte2 as
(select c1.book_Title,c1.book_copies_No_Of_Copies,c1.book_copies_BranchID,lb.library_branch_BranchName
from cte1 as c1
join tbl_library_branch as lb
on c1.book_copies_BranchID = lb.library_branch_BranchID)
select  library_branch_BranchName,book_Title,book_copies_No_Of_Copies
 from cte2
 where book_Title="The Lost Tribe";

-- How many copies of the book titled "The Lost Tribe" are owned by each library branch?

with cte1 as
(select b.book_Title,l.book_loans_BranchID
from tbl_book as b
join tbl_book_loans as l
on b.book_BookID= l.book_loans_BookID),
cte2 as
(select c1.book_Title,lb.library_branch_BranchName
from cte1 as c1
join tbl_library_branch as lb
on c1.book_loans_BranchID = lb.library_branch_BranchID)
select count(book_Title) as 'The Lost Tribe', library_branch_BranchName
 from cte2
 group by library_branch_BranchName;

-- Retrieve the names of all borrowers who do not have any books checked out.

select borrower_CardNo, borrower_BorrowerName
from tbl_library_borrower
where borrower_CardNo not in( SELECT book_loans_CardNo FROM tbl_book_loans); 

-- For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 

with cte1 as
(select lb.library_branch_BranchName, l.book_loans_BookID, l.book_loans_BranchID, l.book_loans_CardNo,l.book_loans_DueDate
from tbl_library_branch as lb
join tbl_book_loans as l
on lb.library_branch_BranchID = l.book_loans_BranchID),
cte2 as
(select c1.library_branch_BranchName, c1.book_loans_BookID, c1.book_loans_BranchID, c1.book_loans_CardNo,c1.book_loans_DueDate,b.book_Title
from cte1 as c1
join tbl_book as b
on c1.book_loans_BookID = b.book_BookID),
cte3 as
(select  c2.library_branch_BranchName, c2.book_loans_BookID, c2.book_loans_BranchID, c2.book_loans_CardNo,c2.book_loans_DueDate,c2.book_Title, lbo.borrower_BorrowerName, lbo.borrower_BorrowerAddress
from cte2 as c2
join tbl_library_borrower as lbo)
select library_branch_BranchName, book_loans_DueDate,book_Title, borrower_BorrowerName, borrower_BorrowerAddress
from cte3
where library_branch_BranchName= "Sharpstown" and book_loans_DueDate= '2018-03-02';

-- For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

select lb.library_branch_BranchName , count(*) as total
from tbl_library_branch as lb
join tbl_book_loans as l
on lb.library_branch_BranchID = l.book_loans_BranchID
group by lb.library_branch_BranchName
order by total;

-- Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

with cte1 as 
(select tlb.borrower_CardNo,tlb.borrower_BorrowerName,tlb.borrower_BorrowerAddress,l.book_loans_BookID,l.book_loans_CardNo
from tbl_library_borrower as tlb
join tbl_book_loans as l
on tlb.borrower_CardNo = l.book_loans_CardNo),
cte2 as
(select c1.borrower_BorrowerName,c1.borrower_BorrowerAddress,c1.book_loans_BookID,c1.book_loans_CardNo,b.book_Title
from cte1 as c1
join tbl_book as b
on c1.book_loans_BookID= b.book_BookID)
select borrower_BorrowerName, borrower_BorrowerAddress , book_loans_BookID as total
from cte2
where book_loans_BookID>'5'
order by total;


-- For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

with cte1 as 
(select b.book_BookID, b.book_Title, ba.book_authors_AuthorID, ba.book_authors_AuthorName
from  tbl_book as b
join tbl_book_authors as ba
on b.book_BookID= ba.book_authors_BookID),
cte2 as
(select  c1.book_BookID, c1.book_Title, c1.book_authors_AuthorID, c1.book_authors_AuthorName,c.book_copies_BranchID,c.book_copies_No_Of_Copies
from cte1 as c1
join tbl_book_copies as c
on c1.book_BookID = c.book_copies_BookID),
cte3 as 
(select c2.book_BookID, c2.book_Title, c2.book_authors_AuthorID, c2.book_authors_AuthorName,c2.book_copies_BranchID,c2.book_copies_No_Of_Copies,libb.library_branch_BranchName
from cte2 as c2
join tbl_library_branch as libb
on c2.book_copies_BranchID = libb.library_branch_BranchID)
select book_Title,  book_authors_AuthorName,book_copies_No_Of_Copies,library_branch_BranchName
from cte3
where book_authors_AuthorName= "Stephen King" and library_branch_BranchName="Central";