<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <sch:ns uri="http://sc2-mined-data/gamedata/core" prefix="core"/>
    <xsl:include href="util.xsl"/>
    
    <sch:pattern id="resovle-cross-references">
        <sch:rule context="core:Class[@superClass]">
            <sch:assert test="key('class-by-name', @superClass)">
                Can't resove @superClass: <sch:value-of select="@superClass"/>
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="core:Field">
            <sch:assert test="key('type-by-name', @type)">
                Can't resove @type: <sch:value-of select="@type"/>
            </sch:assert>
            <sch:assert test="if(@indexEnum) then key('enum-by-name', @indexEnum) else true()">
                Can't resove @indexEnum: <sch:value-of select="@indexEnum"/>
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="check-no-duplicate-types">
        <sch:rule context="element(*, core:Type)">
            <sch:assert test="count(key('type-by-name', @name)) = 1">
                Dulicate type <sch:value-of select="name()"/> - <sch:value-of select="@name"/>"/>
            </sch:assert>
        </sch:rule> 
    </sch:pattern>

    <sch:pattern id="check-class-hierarchy">
        <sch:rule context="core:Class">
            <sch:assert test=". except core:class-hierarchy(.)">
                Cycle in hierarchy of class <sch:value-of select="@name"/>
            </sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern id="check-category-conformance">
        <sch:rule context="core:Enum[@category ne 'Unknown']">
            <sch:assert test="@category eq 'Enum'">
                Unexpected @category of <sch:value-of select="@name"/>, the @category of Enum type should be Enum or Unknown. 
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="core:Class[@category ne 'Unknown']">
            <sch:assert test="@category eq 'Struct'">
                Unexpected @category of <sch:value-of select="@name"/>, the @category of Class type should be Struct or Unknown. 
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="core:UnderlyingType">
            <sch:assert test="@category ne 'Enum' and @category ne 'Struct'">
                Unexpected @category of <sch:value-of select="@name"/>, the @category of Type type should not be Enum or Struct. 
            </sch:assert>
        </sch:rule> 
    </sch:pattern>
    
    <sch:pattern id="check-flags-type-must-be-array">
        <sch:rule context="core:Field[key('type-by-name', @type)/@category eq 'Flags']">
            <sch:assert test="@array eq true()">
                The @category of <sch:value-of select="@name"/>'s type is Flags, the @array of the Field must be true. 
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>