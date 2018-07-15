DROP FUNCTION IF EXISTS tmp_borrar_huerfanos();

CREATE FUNCTION tmp_borrar_huerfanos() RETURNS void
AS $$
DECLARE
  v_nombreProyecto VARCHAR;
BEGIN

SELECT 'unNombreProyecto' INTO v_nombreProyecto;

-- BORRAMOS CIs HUERFANOS
DELETE
  FROM desarrollo.apex_item_objeto aio
 WHERE aio.objeto IN (SELECT ao.objeto
                        FROM desarrollo.apex_objeto ao
                       WHERE ao.objeto NOT IN (SELECT objeto
                                               FROM desarrollo.apex_item_objeto
                                               WHERE proyecto = v_nombreProyecto)
                         AND ao.proyecto = v_nombreProyecto
                         AND ao.clase = 'toba_ci')
   AND aio.proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_eventos_pantalla aep
 WHERE aep.objeto_ci IN (SELECT ao.objeto
                          FROM desarrollo.apex_objeto ao
                         WHERE ao.objeto NOT IN (SELECT objeto
                                                 FROM desarrollo.apex_item_objeto
                                                 WHERE proyecto = v_nombreProyecto)
                           AND ao.proyecto = v_nombreProyecto
                           AND ao.clase = 'toba_ci')
   AND aep.proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_objeto_ci_pantalla aocp
 WHERE aocp.objeto_ci IN (SELECT ao.objeto
                            FROM desarrollo.apex_objeto ao
                           WHERE ao.objeto NOT IN (SELECT objeto
                                                   FROM desarrollo.apex_item_objeto
                                                   WHERE proyecto = v_nombreProyecto)
                             AND ao.proyecto = v_nombreProyecto
                             AND ao.clase = 'toba_ci')
   AND aocp.objeto_ci_proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_objeto_mt_me aome
 WHERE aome.objeto_mt_me IN (SELECT ao.objeto
                              FROM desarrollo.apex_objeto ao
                             WHERE ao.objeto NOT IN (SELECT objeto
                                                     FROM desarrollo.apex_item_objeto
                                                     WHERE proyecto = v_nombreProyecto)
                               AND ao.proyecto = v_nombreProyecto
                               AND ao.clase = 'toba_ci')
   AND aome.objeto_mt_me_proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_objeto_eventos aoe
 WHERE aoe.objeto IN (SELECT ao.objeto
                        FROM desarrollo.apex_objeto ao
                       WHERE ao.objeto NOT IN (SELECT objeto
                                               FROM desarrollo.apex_item_objeto
                                               WHERE proyecto = v_nombreProyecto)
                         AND ao.proyecto = v_nombreProyecto
                         AND ao.clase = 'toba_ci')
   AND aoe.proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_objeto ao
 WHERE ao.objeto NOT IN (SELECT objeto
                         FROM desarrollo.apex_item_objeto
                         WHERE proyecto = v_nombreProyecto)
   AND ao.proyecto = v_nombreProyecto
   AND ao.clase = 'toba_ci';

-- BORRAMOS FORMULARIOS HUERFANOS

DELETE
  FROM desarrollo.apex_objeto_ei_formulario_ef aoef
 WHERE aoef.objeto_ei_formulario_proyecto = v_nombreProyecto
   AND aoef.objeto_ei_formulario
       IN (SELECT ao.objeto
             FROM desarrollo.apex_objeto ao
            WHERE ao.proyecto = v_nombreProyecto
              AND ao.clase = 'toba_ei_formulario'
              AND ao.objeto
                  NOT IN (SELECT aod.objeto_proveedor
                            FROM desarrollo.apex_objeto_dependencias aod
                           WHERE aod.proyecto = v_nombreProyecto));

DELETE
  FROM desarrollo.apex_objetos_pantalla aop
 WHERE aop.proyecto = v_nombreProyecto
   AND aop.dep_id
       IN (SELECT aod.objeto_proveedor
             FROM desarrollo.apex_objeto_dependencias aod
            WHERE aod.proyecto = v_nombreProyecto
              AND aod.objeto_proveedor
                  IN (SELECT ao.objeto
                        FROM desarrollo.apex_objeto ao
                       WHERE ao.proyecto = v_nombreProyecto
                         AND ao.clase = 'toba_ei_formulario'
                      	  AND ao.objeto
                             NOT IN (SELECT aod.objeto_proveedor
                                       FROM desarrollo.apex_objeto_dependencias aod
                                      WHERE aod.proyecto = v_nombreProyecto)));

DELETE
  FROM desarrollo.apex_objeto_dependencias aod
 WHERE aod.proyecto = v_nombreProyecto
   AND aod.objeto_proveedor
       IN (SELECT ao.objeto
             FROM desarrollo.apex_objeto ao
            WHERE ao.proyecto = v_nombreProyecto
              AND ao.clase = 'toba_ei_formulario'
           	  AND ao.objeto
                  NOT IN (SELECT aod.objeto_proveedor
                            FROM desarrollo.apex_objeto_dependencias aod
                           WHERE aod.proyecto = v_nombreProyecto));

DELETE
 FROM desarrollo.apex_objeto_ut_formulario aouf
WHERE aouf.objeto_ut_formulario
      IN (SELECT ao.objeto
            FROM desarrollo.apex_objeto ao
           WHERE ao.proyecto = v_nombreProyecto
             AND ao.clase = 'toba_ei_formulario'
             AND ao.objeto
                 NOT IN (SELECT aod.objeto_proveedor
                           FROM desarrollo.apex_objeto_dependencias aod
                          WHERE aod.proyecto = v_nombreProyecto))
  AND aouf.objeto_ut_formulario_proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_objeto_eventos aoe
 WHERE aoe.objeto
       IN (SELECT ao.objeto
             FROM desarrollo.apex_objeto ao
            WHERE ao.proyecto = v_nombreProyecto
              AND ao.clase = 'toba_ei_formulario'
           	  AND ao.objeto
                  NOT IN (SELECT aod.objeto_proveedor
                            FROM desarrollo.apex_objeto_dependencias aod
                           WHERE aod.proyecto = v_nombreProyecto))
   AND aoe.proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_objeto ao
 WHERE ao.proyecto = v_nombreProyecto
   AND ao.clase = 'toba_ei_formulario'
	 AND ao.objeto
       NOT IN (SELECT aod.objeto_proveedor
                 FROM desarrollo.apex_objeto_dependencias aod
                WHERE aod.proyecto = v_nombreProyecto);

-- BORRAMOS FORMULARIOS HUERFANOS

DELETE
  FROM desarrollo.apex_objeto_ei_cuadro_columna aoecc
 WHERE aoecc.objeto_cuadro
       IN (SELECT ao.objeto
             FROM desarrollo.apex_objeto ao
            WHERE ao.proyecto = v_nombreProyecto
              AND ao.clase = 'toba_ei_cuadro'
            	AND ao.objeto
                  NOT IN (SELECT aod.objeto_proveedor
                            FROM desarrollo.apex_objeto_dependencias aod
                           WHERE aod.proyecto = v_nombreProyecto))
   AND aoecc.objeto_cuadro_proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_objeto_cuadro aoc
 WHERE aoc.objeto_cuadro
       IN (SELECT ao.objeto
             FROM desarrollo.apex_objeto ao
            WHERE ao.proyecto = v_nombreProyecto
              AND ao.clase = 'toba_ei_cuadro'
            	AND ao.objeto
                  NOT IN (SELECT aod.objeto_proveedor
                            FROM desarrollo.apex_objeto_dependencias aod
                           WHERE aod.proyecto = v_nombreProyecto))
   AND aoc.objeto_cuadro_proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_objeto_eventos aoe
 WHERE aoe.objeto
       IN (SELECT ao.objeto
             FROM desarrollo.apex_objeto ao
            WHERE ao.proyecto = v_nombreProyecto
              AND ao.clase = 'toba_ei_cuadro'
            	AND ao.objeto
                  NOT IN (SELECT aod.objeto_proveedor
                            FROM desarrollo.apex_objeto_dependencias aod
                           WHERE aod.proyecto = v_nombreProyecto))
   AND aoe.proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_objeto ao
 WHERE ao.proyecto = v_nombreProyecto
   AND ao.clase = 'toba_ei_cuadro'
	 AND ao.objeto
       NOT IN (SELECT aod.objeto_proveedor
                 FROM desarrollo.apex_objeto_dependencias aod
                WHERE aod.proyecto = v_nombreProyecto);

-- BORRAMOS FORMULARIOS HUERFANOS

DELETE
FROM desarrollo.apex_objeto_ei_filtro_col aoefc
WHERE aoefc.objeto_ei_filtro
     IN (SELECT ao.objeto
           FROM desarrollo.apex_objeto ao
          WHERE ao.proyecto = v_nombreProyecto
            AND ao.clase = 'toba_ei_filtro'
            AND ao.objeto
                NOT IN (SELECT aod.objeto_proveedor
                          FROM desarrollo.apex_objeto_dependencias aod
                         WHERE aod.proyecto = v_nombreProyecto))
 AND aoefc.objeto_ei_filtro_proyecto = v_nombreProyecto;

DELETE
FROM desarrollo.apex_objeto_ei_filtro aoef
WHERE aoef.objeto_ei_filtro
     IN (SELECT ao.objeto
           FROM desarrollo.apex_objeto ao
          WHERE ao.proyecto = v_nombreProyecto
            AND ao.clase = 'toba_ei_filtro'
            AND ao.objeto
                NOT IN (SELECT aod.objeto_proveedor
                          FROM desarrollo.apex_objeto_dependencias aod
                         WHERE aod.proyecto = v_nombreProyecto))
 AND aoef.objeto_ei_filtro_proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_objeto_eventos aoe
 WHERE aoe.objeto
       IN (SELECT ao.objeto
             FROM desarrollo.apex_objeto ao
            WHERE ao.proyecto = v_nombreProyecto
              AND ao.clase = 'toba_ei_filtro'
              AND ao.objeto
                  NOT IN (SELECT aod.objeto_proveedor
                            FROM desarrollo.apex_objeto_dependencias aod
                           WHERE aod.proyecto = v_nombreProyecto))
   AND aoe.proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_objeto ao
 WHERE ao.proyecto = v_nombreProyecto
   AND ao.clase = 'toba_ei_filtro'
   AND ao.objeto
       NOT IN (SELECT aod.objeto_proveedor
                 FROM desarrollo.apex_objeto_dependencias aod
                WHERE aod.proyecto = v_nombreProyecto);

-- BORRAMOS CNs HUERFANOS

DELETE
  FROM desarrollo.apex_objeto ao
 WHERE ao.objeto NOT IN (SELECT objeto
                          FROM desarrollo.apex_item_objeto
                          WHERE proyecto = v_nombreProyecto)
   AND ao.proyecto = v_nombreProyecto
   AND ao.clase = 'toba_cn';

-- BORRAMOS LOS DRs HUERFANOS
DELETE
  FROM desarrollo.apex_objeto_datos_rel aodr
 WHERE aodr.objeto IN (SELECT ao.objeto
                         FROM desarrollo.apex_objeto ao
                        WHERE ao.objeto NOT IN (SELECT aod.objeto_proveedor
                                                  FROM desarrollo.apex_objeto_dependencias aod
                                                 WHERE aod.proyecto = v_nombreProyecto)
                          AND ao.proyecto = v_nombreProyecto
                          AND ao.clase = 'toba_datos_relacion')
   AND aodr.proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_objeto ao
 WHERE ao.objeto NOT IN (SELECT aod.objeto_proveedor
                           FROM desarrollo.apex_objeto_dependencias aod
                          WHERE aod.proyecto = v_nombreProyecto)
   AND ao.proyecto = v_nombreProyecto
   AND ao.clase = 'toba_datos_relacion';

-- BORRAMOS TODOS LOS DTs HUERFANOS

DELETE
  FROM desarrollo.apex_objeto_db_registros_col aodrc
 WHERE aodrc.objeto IN (SELECT ao.objeto
                         FROM desarrollo. apex_objeto ao
                        WHERE ao.objeto NOT IN (SELECT aod.objeto_proveedor
                                                  FROM desarrollo.apex_objeto_dependencias aod
                                                 WHERE aod.proyecto = v_nombreProyecto
                                               UNION
                                                 SELECT carga_dt
                                                 FROM desarrollo.apex_objeto_ei_formulario_ef
                                                WHERE objeto_ei_formulario_proyecto = v_nombreProyecto
                                                  AND carga_dt IS NOT NULL)
                          AND ao.proyecto = v_nombreProyecto)
   AND aodrc.objeto_proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo.apex_objeto_db_registros aodr
 WHERE aodr.objeto IN (SELECT ao.objeto
                         FROM desarrollo. apex_objeto ao
                        WHERE ao.objeto NOT IN (SELECT aod.objeto_proveedor
                                                  FROM desarrollo.apex_objeto_dependencias aod
                                                 WHERE aod.proyecto = v_nombreProyecto
                                               UNION
                                                 SELECT carga_dt
                                                 FROM desarrollo.apex_objeto_ei_formulario_ef
                                                WHERE objeto_ei_formulario_proyecto = v_nombreProyecto
                                                  AND carga_dt IS NOT NULL)
                          AND ao.proyecto = v_nombreProyecto)
   AND aodr.objeto_proyecto = v_nombreProyecto;

DELETE
  FROM desarrollo. apex_objeto ao
 WHERE ao.objeto NOT IN (SELECT aod.objeto_proveedor
                           FROM desarrollo.apex_objeto_dependencias aod
                          WHERE aod.proyecto = v_nombreProyecto
                        UNION
                          SELECT carga_dt
                          FROM desarrollo.apex_objeto_ei_formulario_ef
                         WHERE objeto_ei_formulario_proyecto = v_nombreProyecto
                           AND carga_dt IS NOT NULL)
   AND ao.proyecto = v_nombreProyecto
   AND ao.clase = 'toba_datos_tabla';
END $$
LANGUAGE plpgsql;

SELECT tmp_borrar_huerfanos();

DROP FUNCTION IF EXISTS tmp_borrar_huerfanos();