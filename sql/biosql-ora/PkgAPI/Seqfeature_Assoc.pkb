--
-- API Package Body for Seqfeature_Assoc.
--
-- Scaffold auto-generated by gen-api.pl (H.Lapp, 2002).
--
-- $Id: Seqfeature_Assoc.pkb,v 1.1.1.1 2002-08-13 19:51:10 lapp Exp $
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
PACKAGE BODY FeaA IS

CURSOR FeaA_c (
		FeaA_SRC_FEA_OID IN SG_SEQFEATURE_ASSOC.SRC_FEA_OID%TYPE,
		FeaA_TGT_FEA_OID IN SG_SEQFEATURE_ASSOC.TGT_FEA_OID%TYPE,
		FeaA_ONT_OID	 IN SG_SEQFEATURE_ASSOC.ONT_OID%TYPE)
RETURN SG_SEQFEATURE_ASSOC%ROWTYPE IS
	SELECT t.* FROM SG_SEQFEATURE_ASSOC t
	WHERE
		t.SRC_FEA_OID = FeaA_SRC_FEA_OID
	AND	t.TGT_FEA_OID = FeaA_TGT_FEA_OID
	AND	t.ONT_OID     = FeaA_ONT_OID
	;

FUNCTION get_oid(
		SRC_FEA_OID	IN SG_SEQFEATURE_ASSOC.SRC_FEA_OID%TYPE DEFAULT NULL,
		TGT_FEA_OID	IN SG_SEQFEATURE_ASSOC.TGT_FEA_OID%TYPE DEFAULT NULL,
		ONT_OID	IN SG_SEQFEATURE_ASSOC.ONT_OID%TYPE DEFAULT NULL,
		FeaA_RANK	IN SG_SEQFEATURE_ASSOC.RANK%TYPE DEFAULT NULL,
		Ont_NAME	IN SG_ONTOLOGY_TERM.NAME%TYPE DEFAULT NULL,
		Ont_IDENTIFIER	IN SG_ONTOLOGY_TERM.IDENTIFIER%TYPE DEFAULT NULL,
		Src_Fea_ENT_OID	IN SG_SEQFEATURE.ENT_OID%TYPE DEFAULT NULL,
		Src_Fea_RANK	IN SG_SEQFEATURE.RANK%TYPE DEFAULT NULL,
		Src_Fea_ONT_OID	IN SG_SEQFEATURE.ONT_OID%TYPE DEFAULT NULL,
		Tgt_Fea_ENT_OID	IN SG_SEQFEATURE.ENT_OID%TYPE DEFAULT NULL,
		Tgt_Fea_RANK	IN SG_SEQFEATURE.RANK%TYPE DEFAULT NULL,
		Tgt_Fea_ONT_OID	IN SG_SEQFEATURE.ONT_OID%TYPE DEFAULT NULL,
		do_DML		IN NUMBER DEFAULT BSStd.DML_NO)
RETURN INTEGER
IS
	pk	INTEGER DEFAULT NULL;
	FeaA_row FeaA_c%ROWTYPE;
	ONT_OID_	SG_ONTOLOGY_TERM.OID%TYPE DEFAULT ONT_OID;
	SRC_FEA_OID_	SG_SEQFEATURE.OID%TYPE DEFAULT SRC_FEA_OID;
	TGT_FEA_OID_	SG_SEQFEATURE.OID%TYPE DEFAULT TGT_FEA_OID;
BEGIN
	-- look up SG_ONTOLOGY_TERM
	IF (ONT_OID_ IS NULL) THEN
		ONT_OID_ := Ont.get_oid(
				Ont_NAME => Ont_NAME,
				Ont_IDENTIFIER => Ont_IDENTIFIER);
	END IF;
	-- look up source SG_SEQFEATURE
	IF (SRC_FEA_OID_ IS NULL) THEN
		SRC_FEA_OID_ := Fea.get_oid(
				ENT_OID => Src_Fea_ENT_OID,
				Fea_RANK => Src_Fea_RANK,
				ONT_OID => Src_Fea_ONT_OID);
	END IF;
	-- look up target SG_SEQFEATURE
	IF (TGT_FEA_OID_ IS NULL) THEN
		TGT_FEA_OID_ := Fea.get_oid(
				ENT_OID => Tgt_Fea_ENT_OID,
				Fea_RANK => Tgt_Fea_RANK,
				ONT_OID => Tgt_Fea_ONT_OID);
	END IF;
	-- look up
	FOR FeaA_row IN FeaA_c (Src_Fea_Oid_, Tgt_Fea_Oid_, Ont_Oid_) LOOP
	        pk := 1;
	END LOOP;
	-- insert/update if requested
	IF (pk IS NULL) AND 
	   ((do_DML = BSStd.DML_I) OR (do_DML = BSStd.DML_UI)) THEN
	    	-- look up foreign keys if not provided:
		-- look up SG_ONTOLOGY_TERM successful?
		IF (ONT_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Ont <' || Ont_NAME || '|' || Ont_IDENTIFIER || '>');
		END IF;
		-- look up source SG_SEQFEATURE successful?
		IF (SRC_FEA_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Fea <' || Src_Fea_ENT_OID || '|' || Src_Fea_RANK || '|' || Src_Fea_ONT_OID || '>');
		END IF;
		-- look up target SG_SEQFEATURE successful?
		IF (TGT_FEA_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Fea <' || Tgt_Fea_ENT_OID || '|' || Tgt_Fea_RANK || '|' || Tgt_Fea_ONT_OID || '>');
		END IF;
	    	-- insert the record and obtain the primary key
	    	pk := do_insert(
		        SRC_FEA_OID => SRC_FEA_OID_,
		        TGT_FEA_OID => TGT_FEA_OID_,
			ONT_OID => ONT_OID_,
			RANK => FeaA_RANK);
	ELSIF (do_DML = BSStd.DML_U) OR (do_DML = BSStd.DML_UI) THEN
	        -- update the record (note that not provided FKs will not
		-- be changed nor looked up)
		do_update(
			FeaA_SRC_FEA_OID => SRC_FEA_OID_,
		        FeaA_TGT_FEA_OID => TGT_FEA_OID_,
			FeaA_ONT_OID => ONT_OID_,
			FeaA_RANK => FeaA_RANK);
	END IF;
	-- return the primary key
	RETURN pk;
END;

FUNCTION do_insert(
		SRC_FEA_OID	IN SG_SEQFEATURE_ASSOC.SRC_FEA_OID%TYPE,
		TGT_FEA_OID	IN SG_SEQFEATURE_ASSOC.TGT_FEA_OID%TYPE,
		ONT_OID	IN SG_SEQFEATURE_ASSOC.ONT_OID%TYPE,
		RANK	IN SG_SEQFEATURE_ASSOC.RANK%TYPE)
RETURN INTEGER
IS
BEGIN
	-- insert the record
	INSERT INTO SG_SEQFEATURE_ASSOC (
		SRC_FEA_OID,
		TGT_FEA_OID,
		ONT_OID,
		RANK)
	VALUES (SRC_FEA_OID,
		TGT_FEA_OID,
		ONT_OID,
		RANK)
	;
	-- return true
	RETURN 1;
END;

PROCEDURE do_update(
		FeaA_SRC_FEA_OID IN SG_SEQFEATURE_ASSOC.SRC_FEA_OID%TYPE,
		FeaA_TGT_FEA_OID IN SG_SEQFEATURE_ASSOC.TGT_FEA_OID%TYPE,
		FeaA_ONT_OID	IN SG_SEQFEATURE_ASSOC.ONT_OID%TYPE,
		FeaA_RANK	IN SG_SEQFEATURE_ASSOC.RANK%TYPE)
IS
BEGIN
	-- update the record (and leave attributes passed as NULL untouched)
	UPDATE SG_SEQFEATURE_ASSOC
	SET
		RANK = NVL(FeaA_RANK, RANK)
	WHERE SRC_FEA_OID = FeaA_SRC_FEA_OID
	AND   TGT_FEA_OID = FeaA_TGT_FEA_OID
	AND   ONT_OID	  = FeaA_ONT_OID
	;
END;

END FeaA;
/
