create table achat(
id int primary key identity(1,1),
client varchar(30),
tarif float,
[date] date
)
insert into achat values('Pierre',102,'2012-10-23'),
						('Simon',47,'2012-10-27'),
						('Marie',18,'2012-11-05'),
						('Marie',20,'2012-11-14'),
						('Pierre',160,'2012-12-03');
select * from achat
where tarif > 40;