-- -*-Sql-*- mode (to keep my emacs happy)
--
-- API Package Body for Bioentry_Assoc.
--
-- Scaffold auto-generated by gen-api.pl. gen-api.pl is
-- (c) Hilmar Lapp, lapp@gnf.org, GNF, 2002.
--
-- $GNF: projects/gi/symgene/src/DB/PkgAPI/Bioentry_Assoc.pkb,v 1.11 2003/05/21 06:50:13 hlapp Exp $
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
PACKAGE BODY EntA IS

EntA_cached	SG_BIOENTRY_ASSOC.OID%TYPE DEFAULT NULL;
cache_key		VARCHAR2(1024) DEFAULT NULL;

CURSOR EntA_c (
		EntA_SUBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.SUBJ_ENT_OID%TYPE,
		EntA_OBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.OBJ_ENT_OID%TYPE,
		EntA_TRM_OID	IN SG_BIOENTRY_ASSOC.TRM_OID%TYPE)
RETURN SG_BIOENTRY_ASSOC%ROWTYPE IS
	SELECT t.* FROM SG_BIOENTRY_ASSOC t
	WHERE
		t.SUBJ_ENT_OID = EntA_SUBJ_ENT_OID
	AND	t.OBJ_ENT_OID = EntA_OBJ_ENT_OID
	AND	t.TRM_OID = EntA_TRM_OID
	;

FUNCTION get_oid(
		EntA_OID	IN SG_BIOENTRY_ASSOC.OID%TYPE DEFAULT NULL,
		TRM_OID	IN SG_BIOENTRY_ASSOC.TRM_OID%TYPE,
		OBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.OBJ_ENT_OID%TYPE,
		SUBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.SUBJ_ENT_OID%TYPE,
		EntA_RANK	IN SG_BIOENTRY_ASSOC.RANK%TYPE DEFAULT NULL,
		Trm_NAME	IN SG_TERM.NAME%TYPE DEFAULT NULL,
		ONT_OID	IN SG_TERM.ONT_OID%TYPE DEFAULT NULL,
		ONT_NAME	IN SG_ONTOLOGY.NAME%TYPE DEFAULT NULL,
		Trm_IDENTIFIER	IN SG_TERM.IDENTIFIER%TYPE DEFAULT NULL,
		Subj_Ent_IDENTIFIER	IN SG_BIOENTRY.IDENTIFIER%TYPE DEFAULT NULL,
		Subj_Ent_ACCESSION	IN SG_BIOENTRY.ACCESSION%TYPE DEFAULT NULL,
		Subj_DB_OID	IN SG_BIOENTRY.DB_OID%TYPE DEFAULT NULL,
		Subj_Ent_VERSION	IN SG_BIOENTRY.VERSION%TYPE DEFAULT NULL,
		Obj_Ent_IDENTIFIER	IN SG_BIOENTRY.IDENTIFIER%TYPE DEFAULT NULL,
		Obj_Ent_ACCESSION	IN SG_BIOENTRY.ACCESSION%TYPE DEFAULT NULL,
		Obj_DB_OID	IN SG_BIOENTRY.DB_OID%TYPE DEFAULT NULL,
		Obj_Ent_VERSION	IN SG_BIOENTRY.VERSION%TYPE DEFAULT NULL,
		do_DML		IN NUMBER DEFAULT BSStd.DML_NO)
RETURN SG_BIOENTRY_ASSOC.OID%TYPE
IS
	pk	SG_BIOENTRY_ASSOC.OID%TYPE DEFAULT NULL;
	EntA_row EntA_c%ROWTYPE;
	TRM_OID_	SG_TERM.OID%TYPE DEFAULT TRM_OID;
	OBJ_ENT_OID_	SG_BIOENTRY.OID%TYPE DEFAULT OBJ_ENT_OID;
	SUBJ_ENT_OID_	SG_BIOENTRY.OID%TYPE DEFAULT SUBJ_ENT_OID;
	key_str	VARCHAR2(1024) DEFAULT Trm_NAME || '|' || ONT_OID || '|' || ONT_NAME || '|' || Trm_IDENTIFIER || '|' || Subj_Ent_IDENTIFIER || '|' || Subj_Ent_ACCESSION || '|' || Subj_DB_OID || '|' || Subj_Ent_VERSION || '|' || Obj_Ent_IDENTIFIER || '|' || Obj_Ent_ACCESSION || '|' || Obj_DB_OID || '|' || Obj_Ent_VERSION;
BEGIN
	-- initialize
	IF (do_DML > BSStd.DML_NO) THEN
		pk := EntA_OID;
	END IF;
	-- look up
	IF pk IS NULL THEN
		IF (key_str = cache_key) THEN
			pk := EntA_cached;
		ELSE
			-- reset cache
			cache_key := NULL;
			EntA_cached := NULL;
                	-- look up SG_TERM
                	IF (TRM_OID_ IS NULL) THEN
                		TRM_OID_ := Trm.get_oid(
                			Trm_NAME => Trm_NAME,
                			ONT_OID => ONT_OID,
                			ONT_NAME => ONT_NAME,
                			Trm_IDENTIFIER => Trm_IDENTIFIER);
                	END IF;
                	-- look up SG_BIOENTRY subject
                	IF (SUBJ_ENT_OID_ IS NULL) THEN
                		SUBJ_ENT_OID_ := Ent.get_oid(
                			Ent_IDENTIFIER => Subj_Ent_IDENTIFIER,
                			Ent_ACCESSION => Subj_Ent_ACCESSION,
                			DB_OID => Subj_DB_OID,
                			Ent_VERSION => Subj_Ent_VERSION);
                	END IF;
                	-- look up SG_BIOENTRY object
                	IF (OBJ_ENT_OID_ IS NULL) THEN
                		OBJ_ENT_OID_ := Ent.get_oid(
                			Ent_IDENTIFIER => Obj_Ent_IDENTIFIER,
                			Ent_ACCESSION => Obj_Ent_ACCESSION,
                			DB_OID => Obj_DB_OID,
                			Ent_VERSION => Obj_Ent_VERSION);
                	END IF;
			-- do the look up
			FOR EntA_row IN EntA_c(SUBJ_ENT_OID_, OBJ_ENT_OID_, TRM_OID_) LOOP
		        	pk := EntA_row.OID;
				-- cache result
			    	cache_key := key_str;
			    	EntA_cached := pk;
			END LOOP;
		END IF;
	END IF;
	-- insert if requested (no update)
	IF (pk IS NULL) AND 
	   ((do_DML = BSStd.DML_I) OR (do_DML = BSStd.DML_UI)) THEN
	    	-- look up foreign keys if not provided:
		-- look up SG_TERM successful?
		IF (TRM_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Trm <' || Trm_NAME || '|' || ONT_OID || '|' || ONT_NAME || '|' || Trm_IDENTIFIER || '>');
		END IF;
		-- look up SG_BIOENTRY subject successful?
		IF (SUBJ_ENT_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Ent <' || Subj_Ent_IDENTIFIER || '|' || Subj_Ent_ACCESSION || '|' || Subj_DB_OID || '|' || Subj_Ent_VERSION || '>');
		END IF;
		-- look up SG_BIOENTRY object successful?
		IF (OBJ_ENT_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Ent <' || Obj_Ent_IDENTIFIER || '|' || Obj_Ent_ACCESSION || '|' || Obj_DB_OID || '|' || Obj_Ent_VERSION || '>');
		END IF;
	    	-- insert the record and obtain the primary key
	    	pk := do_insert(
		        TRM_OID => TRM_OID_,
			OBJ_ENT_OID => OBJ_ENT_OID_,
			SUBJ_ENT_OID => SUBJ_ENT_OID_,
			RANK => EntA_RANK);
	ELSIF (do_DML = BSStd.DML_U) OR (do_DML = BSStd.DML_UI) THEN
	        -- update the record (note that not provided FKs will not
		-- be changed nor looked up)
		do_update(
			EntA_OID	=> pk,
		        EntA_TRM_OID => TRM_OID_,
			EntA_OBJ_ENT_OID => OBJ_ENT_OID_,
			EntA_SUBJ_ENT_OID => SUBJ_ENT_OID_,
			EntA_RANK => EntA_RANK);
	END IF;
	-- return the primary key
	RETURN pk;
END;

FUNCTION do_insert(
		TRM_OID	IN SG_BIOENTRY_ASSOC.TRM_OID%TYPE,
		OBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.OBJ_ENT_OID%TYPE,
		SUBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.SUBJ_ENT_OID%TYPE,
		RANK	IN SG_BIOENTRY_ASSOC.RANK%TYPE)
RETURN SG_BIOENTRY_ASSOC.OID%TYPE 
IS
	pk	SG_BIOENTRY_ASSOC.OID%TYPE;
BEGIN
	-- pre-generate the primary key value
	SELECT SG_Sequence_EntA.nextval INTO pk FROM DUAL;
	-- insert the record
	INSERT INTO SG_BIOENTRY_ASSOC (
		OID,
		TRM_OID,
		OBJ_ENT_OID,
		SUBJ_ENT_OID,
		RANK)
	VALUES (pk,
		TRM_OID,
		OBJ_ENT_OID,
		SUBJ_ENT_OID,
		RANK)
	;
	-- return the new pk value
	RETURN pk;
END;

PROCEDURE do_update(
		EntA_OID	IN SG_BIOENTRY_ASSOC.OID%TYPE,
		EntA_TRM_OID	IN SG_BIOENTRY_ASSOC.TRM_OID%TYPE,
		EntA_OBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.OBJ_ENT_OID%TYPE,
		EntA_SUBJ_ENT_OID	IN SG_BIOENTRY_ASSOC.SUBJ_ENT_OID%TYPE,
		EntA_RANK	IN SG_BIOENTRY_ASSOC.RANK%TYPE)
IS
BEGIN
	-- update the record (and leave attributes passed as NULL untouched)
	UPDATE SG_BIOENTRY_ASSOC
	SET
		TRM_OID = NVL(EntA_TRM_OID, TRM_OID),
		OBJ_ENT_OID = NVL(EntA_OBJ_ENT_OID, OBJ_ENT_OID),
		SUBJ_ENT_OID = NVL(EntA_SUBJ_ENT_OID, SUBJ_ENT_OID),
		RANK = NVL(EntA_RANK, RANK)
	WHERE OID = EntA_OID
	;
END;

END EntA;
/

