-- -*-Sql-*- mode (to keep my emacs happy)
--
-- API Package Body for Reference.
--
-- Scaffold auto-generated by gen-api.pl. gen-api.pl is
-- (c) Hilmar Lapp, lapp@gnf.org, GNF, 2002.
--
-- $GNF: projects/gi/symgene/src/DB/PkgAPI/Reference.pkb,v 1.9 2003/05/21 09:33:18 hlapp Exp $
--

--
-- (c) Hilmar Lapp, hlapp at gnf.org, 2002.
-- (c) GNF, Genomics Institute of the Novartis Research Foundation, 2002.
--
-- You may distribute this module under the same terms as Perl.
-- Refer to the Perl Artistic License (see the license accompanying this
-- software package, or see http://www.perl.com/language/misc/Artistic.html)
-- for the terms under which you may use, modify, and redistribute this module.
-- 
-- THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
-- WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
-- MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
--

CREATE OR REPLACE
PACKAGE BODY LRef IS

Ref_cached      SG_REFERENCE.OID%TYPE DEFAULT NULL;
cache_key               VARCHAR2(512) DEFAULT NULL;

CURSOR Ref_DBX_c (
		Ref_DBX_OID	IN SG_REFERENCE.DBX_OID%TYPE)
RETURN SG_REFERENCE%ROWTYPE IS
	SELECT t.* FROM SG_REFERENCE t
	WHERE
		t.DBX_OID = Ref_DBX_OID
	;

CURSOR Ref_CRC_c (
		Ref_CRC	IN SG_REFERENCE.CRC%TYPE)
RETURN SG_REFERENCE%ROWTYPE IS
	SELECT t.* FROM SG_REFERENCE t
	WHERE
		t.CRC = Ref_CRC
	;

FUNCTION get_oid(
		Ref_OID	IN SG_REFERENCE.OID%TYPE DEFAULT NULL,
		Ref_TITLE	IN SG_REFERENCE.TITLE%TYPE DEFAULT NULL,
		Ref_AUTHORS	IN SG_REFERENCE.AUTHORS%TYPE DEFAULT NULL,
		Ref_LOCATION	IN SG_REFERENCE.LOCATION%TYPE DEFAULT NULL,
		Ref_CRC	IN SG_REFERENCE.CRC%TYPE,
		DBX_OID	IN SG_REFERENCE.DBX_OID%TYPE,
		Dbx_ACCESSION	IN SG_DBXREF.ACCESSION%TYPE DEFAULT NULL,
		Dbx_DBNAME	IN SG_DBXREF.DBNAME%TYPE DEFAULT NULL,
		Dbx_VERSION	IN SG_DBXREF.VERSION%TYPE DEFAULT NULL,
		do_DML		IN NUMBER DEFAULT BSStd.DML_NO)
RETURN SG_REFERENCE.OID%TYPE
IS
	pk	SG_REFERENCE.OID%TYPE DEFAULT NULL;
	Ref_row Ref_DBX_c%ROWTYPE;
	DBX_OID_	SG_DBXREF.OID%TYPE DEFAULT DBX_OID;
	key_str	VARCHAR2(512) DEFAULT DBX_OID || '|' || Ref_CRC || '|' || Dbx_ACCESSION || '|' || Dbx_DBNAME || '|' || Dbx_VERSION;
BEGIN
	-- initialize
	IF (do_DML > BSStd.DML_NO) THEN
		pk := Ref_OID;
	END IF;
	-- look up
	IF (pk IS NULL) THEN
		IF (key_str = cache_key) THEN
			pk := Ref_cached;
		ELSE
			-- reset cache
			cache_key := NULL;
			Ref_cached := NULL;
			-- do the look up
			IF (Ref_CRC IS NOT NULL) THEN
				FOR Ref_row IN Ref_CRC_c(Ref_CRC) LOOP
		        		pk := Ref_row.OID;
				END LOOP;
			END IF;
			-- if still not found try by DBX (MedlineID)
			IF (pk IS NULL) AND
			   (NOT ((DBX_OID_ IS NULL) AND 
			   	 (Dbx_ACCESSION IS NULL))) THEN
				-- look up SG_DBXREF
			   	IF (DBX_OID_ IS NULL) THEN
			      		DBX_OID_ := Dbx.get_oid(
						Dbx_ACCESSION => Dbx_ACCESSION,
						Dbx_DBNAME => Dbx_DBNAME,
						Dbx_VERSION => Dbx_VERSION);
			   	END IF;
			   	FOR Ref_row IN Ref_DBX_c(DBX_OID_) LOOP
		        		pk := Ref_row.OID;
			   	END LOOP;
			END IF;
			IF (pk IS NOT NULL) THEN
				-- cache result
			    	cache_key := key_str;
			    	Ref_cached := pk;
			END IF;
		END IF;
	END IF;
	-- insert/update if requested
	IF (pk IS NULL) AND 
	   ((do_DML = BSStd.DML_I) OR (do_DML = BSStd.DML_UI)) THEN
	    	-- look up foreign keys if not provided:
		-- look up SG_DBXREF (note we may get here if we looked up
		-- the record before by CRC
		IF (DBX_OID_ IS NULL) AND (Ref_CRC IS NOT NULL) THEN
			DBX_OID_ := Dbx.get_oid(
				Dbx_ACCESSION => Dbx_ACCESSION,
				Dbx_DBNAME => Dbx_DBNAME,
				Dbx_VERSION => Dbx_VERSION);
		END IF;
	    	-- insert the record and obtain the primary key
	    	pk := do_insert(
		        TITLE => Ref_TITLE,
			AUTHORS => Ref_AUTHORS,
			LOCATION => Ref_LOCATION,
			CRC => Ref_CRC,
			DBX_OID => DBX_OID_);
	ELSIF (do_DML = BSStd.DML_U) OR (do_DML = BSStd.DML_UI) THEN
	        -- update the record (note that not provided FKs will not
		-- be changed nor looked up)
		do_update(
			Ref_OID	=> pk,
		        Ref_TITLE => Ref_TITLE,
			Ref_AUTHORS => Ref_AUTHORS,
			Ref_LOCATION => Ref_LOCATION,
			Ref_CRC => Ref_CRC,
			Ref_DBX_OID => DBX_OID_);
	END IF;
	-- return the primary key
	RETURN pk;
END;

FUNCTION do_insert(
		TITLE	IN SG_REFERENCE.TITLE%TYPE,
		AUTHORS	IN SG_REFERENCE.AUTHORS%TYPE,
		LOCATION	IN SG_REFERENCE.LOCATION%TYPE,
		CRC	IN SG_REFERENCE.CRC%TYPE,
		DBX_OID	IN SG_REFERENCE.DBX_OID%TYPE)
RETURN SG_REFERENCE.OID%TYPE 
IS
	pk	SG_REFERENCE.OID%TYPE;
BEGIN
	-- pre-generate the primary key value
	SELECT SG_Sequence.nextval INTO pk FROM DUAL;
	-- insert the record
	INSERT INTO SG_REFERENCE (
		OID,
		TITLE,
		AUTHORS,
		LOCATION,
		CRC,
		DBX_OID)
	VALUES (pk,
		TITLE,
		AUTHORS,
		LOCATION,
		CRC,
		DBX_OID)
	;
	-- return the new pk value
	RETURN pk;
END;

PROCEDURE do_update(
		Ref_OID	IN SG_REFERENCE.OID%TYPE,
		Ref_TITLE	IN SG_REFERENCE.TITLE%TYPE,
		Ref_AUTHORS	IN SG_REFERENCE.AUTHORS%TYPE,
		Ref_LOCATION	IN SG_REFERENCE.LOCATION%TYPE,
		Ref_CRC	IN SG_REFERENCE.CRC%TYPE,
		Ref_DBX_OID	IN SG_REFERENCE.DBX_OID%TYPE)
IS
BEGIN
	-- update the record (and leave attributes passed as NULL untouched)
	UPDATE SG_REFERENCE
	SET
		TITLE = NVL(Ref_TITLE, TITLE),
		AUTHORS = NVL(Ref_AUTHORS, AUTHORS),
		LOCATION = NVL(Ref_LOCATION, LOCATION),
		CRC = NVL(Ref_CRC, CRC),
		DBX_OID = NVL(Ref_DBX_OID, DBX_OID)
	WHERE OID = Ref_OID
	;
END;

END LRef;
/

