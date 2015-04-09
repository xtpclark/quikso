-- seems reasonable to me...
CREATE OR REPLACE FUNCTION public.getcustprefsite(text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pCustNumber ALIAS FOR $1;
  _test INTEGER;
  _returnVal TEXT;
BEGIN
  IF (pCustNumber IS NULL) THEN
        RETURN NULL;
  END IF;

  SELECT cust_preferred_warehous_id INTO _test
  FROM cust WHERE (cust_number=pCustNumber);

IF _test NOT IN (SELECT warehous_id FROM warehous WHERE warehous_id=_test) THEN
 SELECT warehous_code INTO _returnVal
  FROM warehous WHERE warehous_id IN (fetchprefwarehousid());
ELSE
 SELECT warehous_code INTO _returnVal
  FROM warehous WHERE (warehous_id=_test);
END IF;

  RETURN _returnVal;
END;
$function$
