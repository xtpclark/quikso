-- Reasonable assumption on the cust_shipvia

CREATE OR REPLACE FUNCTION public.getcustprefshipvia(text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pCustNumber ALIAS FOR $1;
  _test TEXT;
  _returnVal TEXT;
BEGIN
  IF (pCustNumber IS NULL) THEN
        RETURN NULL;
  END IF;

  SELECT cust_shipvia INTO _test
  FROM cust WHERE (cust_number=pCustNumber);

IF _test NOT IN (SELECT shipvia_code FROM shipvia WHERE shipvia_code=_test) THEN
 SELECT fetchdefaultshipvia() INTO _returnVal;
ELSE
 SELECT _test INTO _returnVal;
END IF;

  RETURN _returnVal;
END;
$function$
