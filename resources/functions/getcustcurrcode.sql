-- Function: getcustcurrcode(text)

-- DROP FUNCTION getcustcurrcode(text);

CREATE OR REPLACE FUNCTION getcustcurrcode(text)
  RETURNS text AS
$BODY$
-- Copyright (c) 1999-2014 by OpenMFG LLC, d/b/a xTuple.
-- See www.xtuple.com/CPAL for the full text of the software license.
DECLARE
  pCustNumber ALIAS FOR $1;
  _returnVal TEXT;
BEGIN
  IF (pCustNumber IS NULL) THEN
        RETURN NULL;
  END IF;

  SELECT curr_abbr INTO _returnVal
  FROM cust JOIN curr_symbol ON (cust_curr_id=curr_id)
  WHERE (cust_number=pCustNumber);

  IF (_returnVal IS NULL) THEN
        RAISE EXCEPTION 'Currency not Set for Customer %', pCustNumber;
  END IF;

  RETURN _returnVal;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION getcustcurrcode(text)
  OWNER TO admin;
