-- -*-Sql-*- mode (to keep my emacs happy)
--
-- API Package Body for Chr_Map_Assoc.
--
-- Scaffold auto-generated by gen-api.pl. gen-api.pl is
-- (c) Hilmar Lapp, lapp@gnf.org, GNF, 2002.
--
-- $GNF: projects/gi/symgene/src/DB/PkgAPI/Chr_Map_Assoc.pkb,v 1.17 2003/05/21 09:33:18 hlapp Exp $
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
PACKAGE BODY ChrEntA IS

Ent_Cached		SG_Bioentry.Oid%TYPE DEFAULT NULL;
Ent_Key			VARCHAR2(512) DEFAULT NULL;
Chr_Cached		SG_Bioentry.Oid%TYPE DEFAULT NULL;
Chr_Key			VARCHAR2(512) DEFAULT NULL;
FType_Cached		SG_Term.Oid%TYPE DEFAULT NULL;
FType_Key		VARCHAR2(512) DEFAULT NULL;
FSrc_Cached		SG_Term.Oid%TYPE DEFAULT NULL;
FSrc_Key		VARCHAR2(512) DEFAULT NULL;
Qual_Cached		SG_Term.Oid%TYPE DEFAULT NULL;
Qual_Key		VARCHAR2(512) DEFAULT NULL;
NumQual_Cached		SG_Term.Oid%TYPE DEFAULT NULL;
NumQual_Key		VARCHAR2(512) DEFAULT NULL;
MType_Cached		SG_Term.Oid%TYPE DEFAULT NULL;
MType_Key		VARCHAR2(512) DEFAULT NULL;

FUNCTION get_oid(
		EntSeg_Oid	IN SG_ENT_CHR_MAPS.EntSeg_Oid%TYPE DEFAULT NULL,
		EntSeg_Start_Pos IN SG_ENT_CHR_MAPS.EntSeg_Start_Pos%TYPE DEFAULT NULL,
		EntSeg_End_Pos	IN SG_ENT_CHR_MAPS.EntSeg_End_Pos%TYPE DEFAULT NULL,
		EntSeg_Num	IN SG_ENT_CHR_MAPS.EntSeg_Num%TYPE DEFAULT NULL,
		EntSeg_Type_Name	IN SG_ENT_CHR_MAPS.EntSeg_Type_Name%TYPE DEFAULT NULL,
		EntSeg_Source_Name	IN SG_ENT_CHR_MAPS.EntSeg_Source_Name%TYPE DEFAULT NULL,
		ChrSeg_Oid	IN SG_ENT_CHR_MAPS.ChrSeg_Oid%TYPE DEFAULT NULL,
		ChrSeg_Start_Pos IN SG_ENT_CHR_MAPS.ChrSeg_Start_Pos%TYPE DEFAULT NULL,
		ChrSeg_End_Pos	IN SG_ENT_CHR_MAPS.ChrSeg_End_Pos%TYPE DEFAULT NULL,
		ChrSeg_Strand	IN SG_ENT_CHR_MAPS.ChrSeg_Strand%TYPE DEFAULT NULL,
		ChrSeg_Pct_Identity IN SG_ENT_CHR_MAPS.ChrSeg_Pct_Identity%TYPE DEFAULT NULL,
		Ent_Oid		IN SG_ENT_CHR_MAPS.Ent_Oid%TYPE DEFAULT NULL,
		Ent_Accession	IN SG_ENT_CHR_MAPS.Ent_Accession%TYPE DEFAULT NULL,
		Ent_Identifier	IN SG_ENT_CHR_MAPS.Ent_Identifier%TYPE DEFAULT NULL,
		Ent_Version	IN SG_ENT_CHR_MAPS.Ent_Version%TYPE DEFAULT NULL,
		DB_Oid		IN SG_ENT_CHR_MAPS.DB_Oid%TYPE DEFAULT NULL,
		DB_Name		IN SG_ENT_CHR_MAPS.DB_Name%TYPE DEFAULT NULL,
		DB_Acronym	IN SG_ENT_CHR_MAPS.DB_Acronym%TYPE DEFAULT NULL,
		Ent_Tax_Oid	IN SG_ENT_CHR_MAPS.Ent_Tax_Oid%TYPE DEFAULT NULL,
		Ent_Tax_Name	IN SG_ENT_CHR_MAPS.Ent_Tax_Name%TYPE DEFAULT NULL,
		Ent_Tax_NCBI_Taxon_ID IN SG_ENT_CHR_MAPS.Ent_Tax_NCBI_Taxon_ID%TYPE DEFAULT NULL,
		Chr_Oid		IN SG_ENT_CHR_MAPS.Chr_Oid%TYPE DEFAULT NULL,
		Chr_Name	IN SG_ENT_CHR_MAPS.Chr_Name%TYPE DEFAULT NULL,
		Chr_Accession	IN SG_ENT_CHR_MAPS.Chr_Accession%TYPE DEFAULT NULL,
		Asm_Oid		IN SG_ENT_CHR_MAPS.Asm_Oid%TYPE DEFAULT NULL,
		Asm_Name	IN SG_ENT_CHR_MAPS.Asm_Name%TYPE DEFAULT NULL,
		Asm_Acronym	IN SG_ENT_CHR_MAPS.Asm_Acronym%TYPE DEFAULT NULL,
		Chr_Tax_Oid	IN SG_ENT_CHR_MAPS.Chr_Tax_Oid%TYPE DEFAULT NULL,
		Chr_Tax_Name	IN SG_ENT_CHR_MAPS.Chr_Tax_Name%TYPE DEFAULT NULL,
		Chr_Tax_NCBI_Taxon_ID IN SG_ENT_CHR_MAPS.Chr_Tax_NCBI_Taxon_ID%TYPE DEFAULT NULL,
		do_DML		IN NUMBER DEFAULT BSStd.DML_NO)
RETURN SG_SEQFEATURE.OID%TYPE
IS
	pk		SG_SEQFEATURE.OID%TYPE    DEFAULT NULL;
	Ent_Oid_	SG_BIOENTRY.OID%TYPE      DEFAULT Ent_Oid;
	Chr_Oid_	SG_BIOENTRY.OID%TYPE      DEFAULT Chr_Oid;
	HSP_Oid_	SG_SEQFEATURE.OID%TYPE    DEFAULT EntSeg_Oid;
	Exon_Oid_	SG_SEQFEATURE.OID%TYPE    DEFAULT ChrSeg_Oid;
	Ent_Key_	VARCHAR2(512) DEFAULT
			Ent_Accession || '|' || Ent_Version || '|' || 
			Ent_Identifier || '|' || DB_Oid || '|' || 
			DB_Name || '|' || DB_Acronym;
	Chr_Key_	VARCHAR2(512) DEFAULT
			Chr_Accession || '|' || Chr_Name || '|' || 
			Asm_Oid || '|' || Asm_Name || '|' || Asm_Acronym;
	FType_Key_	VARCHAR2(512) DEFAULT EntSeg_Type_Name;
	FType_Oid_	SG_TERM.OID%TYPE;
	FSrc_Key_	VARCHAR2(512) DEFAULT EntSeg_Source_Name;
	FSrc_Oid_	SG_TERM.OID%TYPE;
	Qual_Name	SG_TERM.NAME%TYPE DEFAULT 'Pct_Identity';
	Qual_Key_	VARCHAR2(512) DEFAULT Qual_Name;
	Qual_Oid_	SG_TERM.OID%TYPE;
	NumQual_Name	SG_TERM.NAME%TYPE DEFAULT 'Exon_Num';
	NumQual_Key_	VARCHAR2(512) DEFAULT NumQual_Name;
	NumQual_Oid_	SG_TERM.OID%TYPE;
	MType_Name	SG_TERM.NAME%TYPE DEFAULT 'Genome Alignment';
	MType_Key_	VARCHAR2(512) DEFAULT MType_Name;
	MType_Oid_	SG_TERM.OID%TYPE;
BEGIN
	-- resolve bioentry and chromosome if not specified by OID
	IF Ent_Oid_ IS NULL THEN
		-- cached?
		IF Ent_Key_ = Ent_Key THEN
			Ent_Oid_ := Ent_Cached;
		ELSE
			-- look up
			Ent_Oid_ := Ent.get_oid(
				Ent_ACCESSION  => Ent_ACCESSION,
				Ent_VERSION    => Ent_VERSION,
				Ent_IDENTIFIER => Ent_IDENTIFIER,
				DB_OID         => DB_OID,
				DB_NAME        => DB_NAME,
				DB_ACRONYM     => DB_ACRONYM);
			-- and cache if found
			IF Ent_Oid_ IS NOT NULL THEN
				Ent_Key := Ent_Key_;
				Ent_Cached := Ent_Oid_;
			END IF;
		END IF;
	END IF;
	IF Chr_Oid_ IS NULL THEN
		IF Chr_Key_ = Chr_Key THEN
			Chr_Oid_ := Chr_Cached;
		ELSE
			-- look up
			Chr_Oid_ := Ent.get_oid(
				Ent_NAME       => Chr_Name,
				Ent_ACCESSION  => Chr_Accession,
				Ent_VERSION    => 0,
				DB_OID         => Asm_OID,
				DB_NAME        => Asm_NAME,
				DB_ACRONYM     => Asm_ACRONYM,
				Tax_Oid        => Chr_Tax_Oid,
				Tan_Name       => Chr_Tax_Name,
				Tax_NCBI_Taxon_ID=> Chr_Tax_NCBI_Taxon_ID,
				-- insert if not present, but don't update
				do_DML => BSStd.DML_I);
			-- and cache if found
			IF Chr_Oid_ IS NOT NULL THEN
				Chr_Key := Chr_Key_;
				Chr_Cached := Chr_Oid_;
			END IF;
		END IF;
	END IF;
	-- resolve ontology terms for type, source, qual, and mapping type
	IF FType_Key_ = FType_Key THEN
		FType_Oid_ := FType_Cached;
	ELSE
		-- look up
		FType_Oid_ := Trm.get_oid(
				Trm_Name       => EntSeg_Type_Name,
				Ont_Name       => 'Alignment Block Types',
				-- insert if not present, but don't update
				do_DML         => BSStd.DML_I);
		-- cache (will always have been found)
		FType_Key := FType_Key;
		FType_Cached := FType_Oid_;
	END IF;
	IF FSrc_Key_ = FSrc_Key THEN
		FSrc_Oid_ := FSrc_Cached;
	ELSE
		-- look up
		FSrc_Oid_ := Trm.get_oid(
				Trm_Name       => EntSeg_Source_Name,
				Ont_Name       => 'SeqFeature Sources',
				-- insert if not present, but don't update
				do_DML         => BSStd.DML_I);
		-- cache (will always have been found)
		FSrc_Key := FSrc_Key;
		FSrc_Cached := FSrc_Oid_;
	END IF;
	IF Qual_Key_ = Qual_Key THEN
		Qual_Oid_ := Qual_Cached;
	ELSE
		-- look up
		Qual_Oid_ := Trm.get_oid(
				Trm_Name       => Qual_Name,
				Ont_Name       => 'Annotation Tags',
				-- insert if not present, but don't update
				do_DML         => BSStd.DML_I);
		-- cache (will always have been found)
		Qual_Key := Qual_Key;
		Qual_Cached := Qual_Oid_;
	END IF;
	IF NumQual_Key_ = NumQual_Key THEN
		NumQual_Oid_ := NumQual_Cached;
	ELSE
		-- look up
		NumQual_Oid_ := Trm.get_oid(
				Trm_Name       => NumQual_Name,
				Ont_Name       => 'Annotation Tags',
				-- insert if not present, but don't update
				do_DML         => BSStd.DML_I);
		-- cache (will always have been found)
		NumQual_Key := NumQual_Key;
		NumQual_Cached := NumQual_Oid_;
	END IF;
	IF MType_Key_ = MType_Key THEN
		MType_Oid_ := MType_Cached;
	ELSE
		-- look up
		MType_Oid_ := Trm.get_oid(
				Trm_Name       => MType_Name,
				Ont_Name       => 'Alignment Types',
				-- insert if not present, but don't update
				do_DML         => BSStd.DML_I);
		-- cache (will always have been found)
		MType_Key := MType_Key;
		MType_Cached := MType_Oid_;
	END IF;
	-- add HSP feature and location
	-- we need a unique (though bogus) number here to keep the UK happy
	SELECT SG_Sequence_Rank.nextval INTO pk FROM DUAL;
	HSP_Oid_ := Fea.do_insert(
				ENT_OID        => ENT_OID_,
				RANK           => pk, --EntSeg_Num,
				TYPE_TRM_OID   => FType_Oid_,
				SOURCE_TRM_OID => FSrc_Oid_,
				Display_Name   => NULL);
	pk := Loc.do_insert(
				Start_Pos      => EntSeg_Start_Pos,
				End_Pos        => EntSeg_End_Pos,
				Strand         => 1,
				Rank           => 1,
				Fea_Oid        => HSP_Oid_,
				DBX_Oid	       => NULL,
				Trm_OID	       => NULL);
	-- add exon feature and location
	-- we need a unique (though bogus) number here to keep the UK happy
	SELECT SG_Sequence_Rank.nextval INTO pk FROM DUAL;
	-- now insert
	Exon_Oid_ := Fea.do_insert(
				ENT_OID        => CHR_OID_,
				RANK           => pk,
				TYPE_TRM_OID   => FType_Oid_,
				SOURCE_TRM_OID => FSrc_Oid_,
				Display_Name   => Ent_Accession);
	pk := Loc.do_insert(
				Start_Pos      => ChrSeg_Start_Pos,
				End_Pos        => ChrSeg_End_Pos,
				Strand         => ChrSeg_Strand,
				Rank           => 1,
				Fea_Oid        => Exon_Oid_,
				DBX_Oid	       => NULL,
				Trm_OID	       => NULL);
	-- add pct_identity qualifier value
	pk := FeaTrmA.do_insert(
				Fea_Oid	       => HSP_Oid_,
				Trm_Oid        => Qual_Oid_,
				Rank           => 1,
				Value          => ChrSeg_Pct_Identity);
	-- add entseg_num qualifier value
	pk := FeaTrmA.do_insert(
				Fea_Oid	       => HSP_Oid_,
				Trm_Oid        => NumQual_Oid_,
				Rank           => 1,
				Value          => EntSeg_Num);
	-- add the subfeature relationship
	pk := FeaA.do_insert(
				Subj_Fea_Oid   => HSP_Oid_,
				Obj_Fea_Oid    => Exon_Oid_,
				Trm_Oid        => MType_Oid_,
				Rank           => 0);
	-- done
	RETURN 1;
END;

PROCEDURE delete_mapping(
		Asm_Name	IN SG_Biodatabase.Name%TYPE,
		DB_Name		IN SG_Biodatabase.Name%TYPE DEFAULT NULL,
		FSrc_Name	IN SG_Term.Name%TYPE DEFAULT NULL)
IS
BEGIN
	DELETE FROM SG_Seqfeature
	WHERE Oid IN (
		SELECT HSP.Oid
		FROM SG_Seqfeature_Assoc FeaA,
		     SG_Seqfeature HSP, SG_Seqfeature Exon,
		     SG_Bioentry Ent, SG_Bioentry Chr,
		     SG_Biodatabase DB, SG_Biodatabase Asm,
		     SG_Term FSrc,
		     SG_Ontology Cat
		WHERE
		     FeaA.Subj_Fea_Oid= HSP.Oid
		AND  FeaA.Obj_Fea_Oid = Exon.Oid
		AND  HSP.Ent_Oid      = Ent.Oid
		AND  Ent.DB_Oid	      = DB.Oid
		AND  Exon.Ent_Oid     = Chr.Oid
		AND  Chr.DB_Oid	      = Asm.Oid
		AND  HSP.Source_Trm_Oid = FSrc.Oid
		AND  FSrc.Ont_Oid     = Cat.Oid
		AND  Cat.Name	      = 'SeqFeature Sources'
		AND  Asm.Name	      = Asm_Name
		AND  FSrc.Name        = NVL(FSrc_Name,FSrc.Name)
		AND  DB.Name	      = NVL(DB_Name,DB.Name)
		UNION
		SELECT Exon.Oid
		FROM SG_Seqfeature_Assoc FeaA,
		     SG_Seqfeature HSP, SG_Seqfeature Exon,
		     SG_Bioentry Ent, SG_Bioentry Chr,
		     SG_Biodatabase DB, SG_Biodatabase Asm,
		     SG_Term FSrc,
		     SG_Ontology Cat
		WHERE
		     FeaA.Subj_Fea_Oid= HSP.Oid
		AND  FeaA.Obj_Fea_Oid = Exon.Oid
		AND  HSP.Ent_Oid      = Ent.Oid
		AND  Ent.DB_Oid	      = DB.Oid
		AND  Exon.Ent_Oid     = Chr.Oid
		AND  Chr.DB_Oid	      = Asm.Oid
		AND  HSP.Source_Trm_Oid = FSrc.Oid
		AND  FSrc.Ont_Oid     = Cat.Oid
		AND  Cat.Name	      = 'SeqFeature Sources'
		AND  Asm.Name	      = Asm_Name
		AND  FSrc.Name        = NVL(FSrc_Name,FSrc.Name)
		AND  DB.Name	      = NVL(DB_Name,DB.Name)
	)
	;
END;

END ChrEntA;
/

