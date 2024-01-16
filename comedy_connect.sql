use comedy_connect;

CREATE TABLE Customer (
  Cust_Id VARCHAR(11) NOT NULL UNIQUE,
  First_Name VARCHAR(255) NOT NULL,
  Last_Name VARCHAR(255) NOT NULL,
  Email VARCHAR(255) NOT NULL UNIQUE,
  Phone_No VARCHAR(255) NOT NULL,
  Address VARCHAR(255) NOT NULL,
  Age INT(11) NOT NULL,
  Username VARCHAR(255) NOT NULL UNIQUE,
  Pwd VARCHAR(255) NOT NULL,
  PRIMARY KEY (Cust_Id)
);


CREATE TABLE Meal (
  Meal_Id VARCHAR(255) NOT NULL,
  Meal_Type VARCHAR(255) NOT NULL,
  Price DECIMAL(10,2) NOT NULL,
  Cust_Id VARCHAR(11) NOT NULL,
  FOREIGN KEY (Cust_Id) REFERENCES Customer (Cust_Id)
);


CREATE TABLE Staff (
  Staff_Id VARCHAR(255) NOT NULL,
  Department VARCHAR(255) NOT NULL,
  F_Name VARCHAR(255) NOT NULL,
  L_Name VARCHAR(255) NOT NULL,
  Pword VARCHAR(255) NOT NULL,
  Uname VARCHAR(255) NOT NULL,
  PRIMARY KEY (Staff_Id)
);



CREATE TABLE Serves (
  Staff_Id VARCHAR(255) NOT NULL,
  Cust_Id VARCHAR(11) NOT NULL,
  FOREIGN KEY (Staff_Id) REFERENCES Staff (Staff_Id),
  FOREIGN KEY (Cust_Id) REFERENCES Customer (Cust_Id)
);


CREATE TABLE Reservation (
  Reservation_Id VARCHAR(11) NOT NULL,
  Mode_of_Res VARCHAR(255) NOT NULL,
  SeatNo INT(11) NOT NULL,
  PRIMARY KEY (Reservation_Id)
);


CREATE TABLE Assists (
  Staff_Id VARCHAR(255) NOT NULL,
  Reservation_Id VARCHAR(11) NOT NULL,
  Cust_Id VARCHAR(11) NOT NULL,
  FOREIGN KEY (Staff_Id) REFERENCES Staff (Staff_Id),
  FOREIGN KEY (Reservation_Id) REFERENCES Reservation (Reservation_Id),
  FOREIGN KEY (Cust_Id) REFERENCES Customer (Cust_Id)
);


CREATE TABLE Shows (
  Show_Id VARCHAR(11) NOT NULL,
  Show_Title VARCHAR(255) NOT NULL,
  Audi_Id VARCHAR(11) NOT NULL,
  Strength INT(11) NOT NULL,
  Artist_Id VARCHAR(11) NOT NULL,
  FOREIGN KEY (Audi_Id) REFERENCES Auditorium (Audi_Id),
  FOREIGN KEY (Artist_Id) REFERENCES Artist (Artist_Id),
  PRIMARY KEY (Show_Id)
);


CREATE TABLE Auditorium (
  Audi_Id VARCHAR(11) NOT NULL,
  Capacity INT(11) NOT NULL,
  City VARCHAR(255) NOT NULL,
  Audi_Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (Audi_Id)
);


CREATE TABLE Review (
  Review_Desc VARCHAR(255) NOT NULL,
  Review_Id VARCHAR(255) NOT NULL,
  Date_of_Review DATE NOT NULL,
  Cust_Id VARCHAR(11) NOT NULL,
  FOREIGN KEY (Cust_Id) REFERENCES Customer (Cust_Id),
  PRIMARY KEY (Review_Id)
);



CREATE TABLE Artist (
  Artist_Id VARCHAR(11) NOT NULL,
  Contact_No VARCHAR(255) NOT NULL,
  Genre VARCHAR(255) NOT NULL,
  PRIMARY KEY (Artist_Id)
);


CREATE TABLE About (
  Artist_Id VARCHAR(11) NOT NULL,
  Review_Id VARCHAR(255) NOT NULL,
  FOREIGN KEY(Artist_Id) REFERENCES Artist (Artist_Id),
  FOREIGN KEY(Review_Id) REFERENCES Review (Review_Id)
);


CREATE TABLE Attends (
  Show_Id VARCHAR(11) NOT NULL,
  Cust_Id VARCHAR(11) NOT NULL,
  FOREIGN KEY (Show_Id) REFERENCES Shows (Show_Id),
  FOREIGN KEY (Cust_Id) REFERENCES Customer (Cust_Id)
);


CREATE TABLE Books_tickets_For (
  Show_Id VARCHAR(11) NOT NULL,
  Cust_Id VARCHAR(11) NOT NULL,
  B_date DATE NOT NULL,
  B_time TIME NOT NULL,
  FOREIGN KEY (Show_Id) REFERENCES Shows (Show_Id),
  FOREIGN KEY (Cust_Id) REFERENCES Customer (Cust_Id)
);

CREATE TABLE Payment (
  Payment_Id VARCHAR(255) NOT NULL,
  Payment_Status VARCHAR(255) NOT NULL,
  No_of_Seats INT(11) NOT NULL,
  Cust_Id VARCHAR(11) NOT NULL,
  PRIMARY KEY (Payment_Id),
  FOREIGN KEY (Cust_Id) REFERENCES Customer (Cust_Id)
  );
  
  select * from customer;
  select * from auditorium;
  select * from staff;
  select * from meal;
  select * from payment;
  select * from reservation;
  select * from review;
  select * from shows;
  select * from assists;
  

  
  SELECT * FROM Customer WHERE Cust_Id = '48-4092198';
  
  SELECT * FROM Shows WHERE Audi_Id = 'Audi_3';
  
  #1. Retrieving the review where the Cust_Id = '08-2796365'
  SELECT * FROM Review WHERE Cust_Id = '08-2796365';
  
  #2. Number of shows attended by a particular customer with Cust_Id = '64-3706063'
  SELECT Cust_Id, COUNT(*) AS TotalShowsAttended
  FROM Attends
  WHERE Cust_Id = '64-3706063';
  
  
  #3. To get the details of shows and the artist performing in the show in a single table.
  SELECT Shows.*, Artist.Contact_No, Artist.Genre
  FROM Shows
  JOIN Artist ON Shows.Artist_Id = Artist.Artist_Id;
  
  #4. Information about customers who have attended shows, including details about the show, auditorium, and the artist
  SELECT
    C.First_Name AS First_Name,
    C.Last_Name AS Last_Name,
    S.Show_Title,
    Au.Audi_Name,
    Ar.Contact_No AS Artist_Contact,
    Ar.Genre
FROM
    customer C
JOIN
    attends A ON C.Cust_Id = A.Cust_Id
JOIN
    shows S ON A.Show_Id = S.Show_Id
JOIN
    auditorium Au ON S.Audi_Id = Au.Audi_Id
JOIN
    artist Ar ON S.Artist_Id = Ar.Artist_Id;
    
#5. Nested query to retrieve all the shows and the artist performing with the artist genre as 'Improv'
SELECT Show_Title, Artist_Id
FROM shows
WHERE Artist_Id IN (SELECT Artist_Id FROM Artist WHERE Genre = 'Improv');

    
#6. Nested SQL query that retrieves information about customers who have left reviews and attended shows:
SELECT
    C.First_Name AS First_Name,
    C.Last_Name AS Last_Name,
    R.Review_Desc,
    R.Date_of_Review
FROM
    Customer C
JOIN
    Review R ON C.Cust_Id = R.Cust_Id
WHERE
    C.Cust_Id IN (
        SELECT
            A.Cust_Id
        FROM
            attends A
        JOIN
            shows S ON A.Show_Id = S.Show_Id
        WHERE
            S.Artist_Id IN (
                SELECT
                    Artist_Id
                FROM
                    Artist
                WHERE
                    Genre = 'Satirical'
            )
    );
    
#6. return the title and artist of all the shows which have attendance less than 30
SELECT s.Show_Title, a.Artist_Id
FROM Shows s
JOIN Artist a ON s.Artist_Id = a.Artist_Id
WHERE (
    SELECT COUNT(*)
    FROM Attends at
    WHERE at.Show_Id = s.Show_Id
) < 30;

#7. >=ALL Find shows where the attendance is greater than or equal to all other shows i.e getting the show with greatest strength
SELECT s.Show_Title, s.Strength
FROM Shows s
WHERE Strength >= ALL (
   SELECT Strength
   FROM Shows
);

#8. >ANY Retrieving the titles of shows where the strength of those shows is greater than at least one strength value in the entire Shows table
SELECT s.Show_Title
FROM Shows s
WHERE Strength > ANY (
   SELECT Strength
   FROM Shows
);


#9. Get First Name and Last Name of customers having age > 40.
SELECT c.FirstName, c.LastName FROM
(SELECT First_Name as FirstName , Last_Name as LastName FROM customer
WHERE Age >40) as c;

#10. Retrieve a list of all customers attending shows with Artist_Id equal to  'Art_11' and 'Art_13'
SELECT c.First_Name, c.Last_Name, s.Show_Id, s.Show_Title, a.Artist_Id
FROM customer c
JOIN attends at ON c.Cust_Id = at.Cust_Id
JOIN shows s ON at.Show_Id = s.Show_Id
JOIN artist a ON s.Artist_Id = a.Artist_Id
WHERE a.Artist_Id = 'Art_11'
UNION
SELECT c.First_Name, c.Last_Name, s.Show_Id, s.Show_Title, a.Artist_Id
FROM customer c
JOIN attends at ON c.Cust_Id = at.Cust_Id
JOIN shows s ON at.Show_Id = s.Show_Id
JOIN artist a ON s.Artist_Id = a.Artist_Id
WHERE a.Artist_Id = 'Art_13';










  
  





