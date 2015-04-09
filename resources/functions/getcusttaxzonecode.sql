CREATE OR REPLACE FUNCTION public.getcusttaxzonecode(text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pCustNumber ALIAS FOR $1;
  _returnVal TEXT;
BEGIN
  IF (pCustNumber IS NULL) THEN
        RETURN NULL;
  END IF;

  SELECT taxzone_code INTO _returnVal
  FROM cust JOIN taxzone ON (cust_taxzone_id=taxzone_id)
  WHERE (cust_number=pCustNumber);

  IF (_returnVal IS NULL) THEN
        RAISE EXCEPTION 'Tax Zone not Set for Customer %', pCustNumber;
  END IF;

  RETURN _returnVal;
END;
$function$
