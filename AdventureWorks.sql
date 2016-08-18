--3
SELECT sum(orderqty)
FROM salesorderdetail sod
INNER JOIN productaw paw ON sod.productid = paw.productid
WHERE paw.listprice > 1000

--4
SELECT DISTINCT caw.companyname
FROM customeraw caw
INNER JOIN salesorderheader soh ON caw.customerid = soh.customerid
WHERE (soh.subtotal + soh.taxamt + soh.freight) > 100000

--5
SELECT sum(orderqty)
FROM customeraw caw
INNER JOIN salesorderheader soh ON caw.customerid = soh.customerid
INNER JOIN salesorderdetail sod ON soh.salesorderid = sod.salesorderid
INNER JOIN productaw paw ON sod.productid = paw.productid
WHERE caw.companyname IN ('Riding Cycles')
	AND paw.NAME IN ('Racing Socks, L')

--6
SELECT sod.salesorderid
	,sod.unitprice
FROM salesorderdetail sod
WHERE sod.orderqty = 1
GROUP BY sod.salesorderid
	,sod.unitprice

--7
SELECT pm.NAME
	,caw.companyname
FROM customeraw caw
INNER JOIN salesorderheader soh ON caw.customerid = soh.customerid
INNER JOIN salesorderdetail sod ON soh.salesorderid = sod.salesorderid
INNER JOIN productaw paw ON sod.productid = paw.productid
INNER JOIN productmodel pm ON paw.productmodelid = pm.productmodelid
WHERE pm.NAME IN ('Racing Socks')
GROUP BY pm.NAME
	,caw.companyname

--8
SELECT pd.description
FROM customeraw caw
INNER JOIN salesorderheader soh ON caw.customerid = soh.customerid
INNER JOIN salesorderdetail sod ON soh.salesorderid = sod.salesorderid
INNER JOIN productaw paw ON sod.productid = paw.productid
INNER JOIN productmodel pm ON paw.productmodelid = pm.productmodelid
INNER JOIN productmodelproductdescription pmpd ON pm.productmodelid = pmpd.productmodelid
INNER JOIN productdescription pd ON pmpd.productdescriptionid = pd.productdescriptionid
WHERE pmpd.culture IN ('fr')
	AND paw.productid IN (736)

--9
SELECT caw.companyname
	,soh.subtotal
	,totalweight
FROM customeraw caw
INNER JOIN salesorderheader soh ON caw.customerid = soh.customerid
INNER JOIN (
	SELECT sod.salesorderid
		,sum(coalesce(paw.weight, 0) * sod.orderqty) totalweight
	FROM salesorderdetail sod
	INNER JOIN productaw paw ON sod.productid = paw.productid
	GROUP BY sod.salesorderid
	) sow ON soh.salesorderid = sow.salesorderid
ORDER BY caw.companyname ASC

--10
SELECT sum(orderqty)
FROM customeraw caw
INNER JOIN customeraddress ca ON caw.customerid = ca.customerid
INNER JOIN address a ON ca.addressid = a.addressid
INNER JOIN salesorderheader soh ON caw.customerid = soh.customerid
INNER JOIN salesorderdetail sod ON soh.salesorderid = sod.salesorderid
INNER JOIN productaw paw ON sod.productid = paw.productid
INNER JOIN productcategory pc ON paw.productcategoryid = pc.productcategoryid
WHERE pc.NAME IN ('Cranksets')
	AND a.city IN ('London')

--11
SELECT ca.customerid
	,coalesce(cmo.mainoffice, '') mainoffice
	,coalesce(csa.shippingaddress, '') shippingaddress
FROM customeraw ca
INNER JOIN (
	SELECT ca.customerid
		,a.addressline1 mainoffice
	FROM customeraddress ca
	INNER JOIN address a ON ca.addressid = a.addressid
	WHERE ca.addresstype IN ('Main Office')
		AND a.city IN ('Dallas')
	) cmo ON ca.customerid = cmo.customerid
LEFT JOIN (
	SELECT ca.customerid
		,a.addressline1 shippingaddress
	FROM customeraddress ca
	INNER JOIN address a ON ca.addressid = a.addressid
	WHERE ca.addresstype IN ('Shipping')
		AND a.city IN ('Dallas')
	) csa ON cmo.customerid = csa.customerid

--12
SELECT soh.salesorderid
	,a.subtotal
	,b.subtotal
	,c.subtotal
FROM salesorderheader soh
INNER JOIN (
	SELECT salesorderid
		,subtotal
	FROM salesorderheader
	) a ON soh.salesorderid = a.salesorderid
INNER JOIN (
	SELECT salesorderid
		,sum(orderqty * unitprice) subtotal
	FROM salesorderdetail
	GROUP BY salesorderid
	) b ON a.salesorderid = b.salesorderid
INNER JOIN (
	SELECT sod.salesorderid
		,sum(sod.orderqty * paw.listprice) subtotal
	FROM salesorderdetail sod
	INNER JOIN productaw paw ON sod.productid = paw.productid
	GROUP BY sod.salesorderid
	) c ON b.salesorderid = c.salesorderid

--13
SELECT sod.productid
	,sum(sod.orderqty)
FROM salesorderdetail sod
GROUP BY sod.productid
ORDER BY sum(sod.orderqty) DESC limit 1
