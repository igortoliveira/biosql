--
-- SQL script to create public synonyms for the schema objects.
-- 
-- $Id$
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

@BS-defs

--
-- Synonyms for tables and views
-- 
set timing off
set heading off
set termout off
set feedback off

spool _syns

SELECT 'DROP PUBLIC SYNONYM ' || view_name || ';'
FROM user_views WHERE view_name LIKE 'SG%';
SELECT 'CREATE PUBLIC SYNONYM ' || view_name || ' FOR ' || view_name || ';'
FROM user_views WHERE view_name LIKE 'SG%';

spool off

set timing on
set heading on
set termout on
set feedback on

start _syns.lst