-- So, assuming that the CURRENT_USER is also a rep, and cust has a salesrep too...

CREATE OR REPLACE FUNCTION public.getcustprefsalesrep(text)
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

  SELECT cust_salesrep_id INTO _test
  FROM cust WHERE (cust_number=pCustNumber);

IF _test NOT IN (SELECT salesrep_id FROM salesrep WHERE salesrep_id=_test) THEN
 SELECT UPPER(current_user) INTO _returnVal;
ELSE
 SELECT salesrep_number INTO _returnVal
  FROM salesrep WHERE (salesrep_id=_test);
END IF;

  RETURN _returnVal;
END;
$function$
