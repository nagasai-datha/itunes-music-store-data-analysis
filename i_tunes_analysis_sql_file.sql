CREATE DATABASE itunemployeees_analysis;

USE itunes_analysis;

SHOW DATABASES;
track
USE itunes_analysis;

SHOW TABLES;

CREATE TABLE employee (
    EmployeeId INT PRIMARY KEY,
    LastName VARCHAR(50),
    FirstName VARCHAR(50),
    Title VARCHAR(100),
    ReportsTo INT,
    levels varchar(10),
    BirthDate varchar(20),
    HireDate varchar(20),
    Address VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    PostalCode VARCHAR(20),
    Phone VARCHAR(30),
    Fax VARCHAR(30),
    Email VARCHAR(100)
);
show tables;

CREATE TABLE customartister (
    CustomerId INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Company VARCHAR(100),
    Address VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    PostalCode VARCHAR(20),
    Phone VARCHAR(30),
    Fax VARCHAR(30),
    Email VARCHAR(100),
    SupportRepId INT,
    FOREIGN KEY (SupportRepId) REFERENCES employee(EmployeeId)
);
show tables;

CREATE TABLE artist (
    ArtistId INT PRIMARY KEY,
    Name VARCHAR(200)
);
show tables;

CREATE TABLE album (
    AlbumId INT PRIMARY KEY,
    Title VARCHAR(200),
    ArtistId INT,
    FOREIGN KEY (ArtistId) REFERENCES artist(ArtistId)
);
show tables;

CREATE TABLE genre (
    GenreId INT PRIMARY KEY,
    Name VARCHAR(100)
);
show tables;

CREATE TABLE media_type (
    MediaTypeId INT PRIMARY KEY,
    Name VARCHAR(100)
);
show tables;

CREATE TABLE track (
    TrackId INT PRIMARY KEY,
    Name VARCHAR(200),
    AlbumId INT,
    MediaTypeId INT,
    GenreId INT,
    Composer VARCHAR(220),
    Milliseconds INT,
    Bytes INT,
    UnitPrice DECIMAL(10,2),
    
    FOREIGN KEY (AlbumId) REFERENCES album(AlbumId),
    FOREIGN KEY (MediaTypeId) REFERENCES media_type(MediaTypeId),
    FOREIGN KEY (GenreId) REFERENCES genre(GenreId)
);
show tables;

CREATE TABLE invoice (
    InvoiceId INT PRIMARY KEY,
    CustomerId INT,
    InvoiceDate DATETIME,
    BillingAddress VARCHAR(100),
    BillingCity VARCHAR(50),
    BillingState VARCHAR(50),
    BillingCountry VARCHAR(50),
    BillingPostalCode VARCHAR(20),
    Total DECIMAL(10,2),
    
    FOREIGN KEY (CustomerId) REFERENCES customer(CustomerId)
);
show tables ;

CREATE TABLE invoice_line (
    InvoiceLineId INT PRIMARY KEY,
    InvoiceId INT,
    TrackId INT,
    UnitPrice DECIMAL(10,2),
    Quantity INT,
    
    FOREIGN KEY (InvoiceId) REFERENCES invoice(InvoiceId),
    FOREIGN KEY (TrackId) REFERENCES track(TrackId)
);
show tables ; 

CREATE TABLE playlist (
    PlaylistId INT PRIMARY KEY,
    Name VARCHAR(200)
);
show tables;

CREATE TABLE playlist_track (
    PlaylistId INT,
    TrackId INT,
    
    PRIMARY KEY (PlaylistId, TrackId),
    FOREIGN KEY (PlaylistId) REFERENCES playlist(PlaylistId),
    FOREIGN KEY (TrackId) REFERENCES track(TrackId)
);
show tables;

SELECT COUNT(*) FROM employee ;


