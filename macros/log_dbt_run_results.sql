{% macro log_dbt_run_results(results) %}

{% if execute %}
    {% for res in results %}
        {% if res.node is not none %}

            insert into cowjacket_catalog.cowjacket_observability.dbt_run_logs
            values (
                '{{ invocation_id }}',
                '{{ res.node.name }}',
                '{{ res.node.resource_type }}',
                '{{ res.node.database }}',
                '{{ res.node.schema }}',
                '{{ res.node.config.materialized }}',
                '{{ res.status }}',
                {{ res.execution_time | default(0) }},
                {{ res.adapter_response.get('rows_affected', 'null') }},
                '{{ target.name }}',
                timestamp('{{ run_started_at }}'),
                current_timestamp()
            );

        {% endif %}
    {% endfor %}
{% endif %}

{% endmacro %}
