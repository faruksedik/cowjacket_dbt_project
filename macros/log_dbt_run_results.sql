{% macro log_dbt_run_results(results) %}

{% if execute %}

insert into cowjacket_catalog.cowjacket_observability.dbt_run_logs
(
    invocation_id,
    model_name,
    resource_type,
    database_name,
    schema_name,
    materialization,
    status,
    execution_time_seconds,
    rows_affected,
    environment,
    run_started_at,
    logged_at
)
values
{% for res in results if res.node is not none %}
(
    '{{ invocation_id }}',
    '{{ res.node.name }}',
    '{{ res.node.resource_type }}',
    '{{ res.node.database_name }}',
    '{{ res.node.schema_name }}',
    '{{ res.node.config.materialized }}',
    '{{ res.status }}',
    {{ res.execution_time | default(0) }},
    {{ res.adapter_response.get('rows_affected', 'null') }},
    '{{ target.name }}',
    timestamp('{{ run_started_at }}'),
    current_timestamp()
){% if not loop.last %},{% endif %}
{% endfor %};

{% endif %}

{% endmacro %}
