---First solution
SELECT ProductNumber, REVERSE(ProductNumber) as Obrni,
CHARINDEX('-',REVERSE(ProductNumber)) as ZadnjiHypen,
RIGHT(ProductNumber,CHARINDEX('-',REVERSE(ProductNumber))-1) as VseOdZadnjega
FROM Production.Product
go
--second not yet solution
SELECT ProductNumber,T.value
FROM Production.Product
CROSS APPLY string_split(ProductNumber,'-') as T


