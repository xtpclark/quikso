CREATE OR REPLACE FUNCTION quikso(text, text, integer)
  RETURNS boolean AS
$BODY$

DECLARE
pCustNumber ALIAS FOR $1;
pItem ALIAS FOR $2;
pQty ALIAS FOR $3;

 _sonumber   TEXT;
 _prefsite   TEXT;
 _prefrep   TEXT;
 _custtax   TEXT;

BEGIN
SELECT fetchsonumber() INTO _sonumber;
SELECT getcustprefsite(pCustNumber) INTO _prefsite;
SELECT getcustprefsalesrep(pCustNumber) INTO _prefrep;
SELECT getcusttaxzonecode(pCustNumber) INTO _custtax;

INSERT INTO api.salesorder (
order_number,
site,
order_date,
pack_date,
sale_type,
sales_rep,
commission,
tax_zone,
customer_number,
-- billto_contact_number,
-- shipto_number,
-- cust_po_number,
currency,
ship_via)

VALUES (
_sonumber,
_prefsite,
(current_date), -- 4
(current_date),
'CUST', -- This needs to get a default salestype, which doesn't exist.
_prefrep,
getsalescommission(UPPER(_prefrep)), -- this should be wrapped in _prefrep CURRENT_USER maybe?
_custtax,
pCustNumber,
-- (SELECT cntct_number FROM cntct WHERE cntct_number=billing_contact_number) AS billto_contact_number,
-- (select shipto_number from api.custshipto where custshipto.customer_number = customer.customer_number
-- cust_po_number
getcustcurrcode(pCustNumber),
getcustprefshipvia(pCustNumber)
);

INSERT INTO api.salesline(
order_number,
item_number,
sold_from_site,
status,
qty_ordered
-- ,
--qty_uom,
--net_unit_price,
--price_uom,
--scheduled_date,
--promise_date
--,tax_type
)

VALUES (
_sonumber,
pItem,
_prefsite,
'O',
pQty);


RETURN TRUE;
END;

$BODY$
  LANGUAGE 'plpgsql';
ALTER FUNCTION quikso(text,text,integer) OWNER TO "admin";
