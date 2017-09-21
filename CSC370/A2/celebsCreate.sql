CREATE TABLE Albums (
  title VARCHAR(100)
);
CREATE TABLE Celebs(
  name VARCHAR(30)
);
CREATE TABLE Enemies (
  celeb1 VARCHAR(30), 
  celeb2 VARCHAR(30)
);
CREATE TABLE MovieTitles(
  title VARCHAR(100)
);
CREATE TABLE Relationships (
  celeb1 VARCHAR(30), 
  celeb2 VARCHAR(30),
  started VARCHAR(15), 
  ended VARCHAR(15)
);
CREATE TABLE Releases (
  celeb VARCHAR(30), 
  album VARCHAR(100)
);
CREATE TABLE StarredIn (
  celeb VARCHAR(30), 
  movie VARCHAR(100)
);
