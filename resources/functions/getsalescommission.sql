CREATE OR REPLACE FUNCTION public.getsalescommission(text)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pSalesRepNumber ALIAS FOR $1;
  _returnVal NUMERIC;
BEGIN
  IF (pSalesRepNumber IS NULL) THEN
    RETURN NULL;
  END IF;

  SELECT salesrep_commission INTO _returnVal
  FROM salesrep
  WHERE (salesrep_number=pSalesRepNumber);

  IF (_returnVal IS NULL) THEN
        RAISE EXCEPTION 'Sales Rep Number % not found.', pSalesRepNumber;
  END IF;

  RETURN _returnVal;
END;
$function$
