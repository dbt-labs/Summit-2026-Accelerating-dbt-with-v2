with source as (

    select * from {{ ref('wynn_demo') }}

),

final as (

    select
        resolved_player_id,
        player_full_name,
        loyalty_card_id,
        casino_player_id,
        pms_guest_id,
        tier,
        tier_credits,
        dedicated_host_id,
        is_hosted = 'Y' as is_hosted,
        gaming_theo_win,
        gaming_actual_win,
        hotel_ancillary_rev,
        comp_dollars_issued,
        blended_worth,
        comp_efficiency_ratio,
        floor_vs_pms_worth_gap,
        carded_sessions,
        hotel_stays,
        days_since_last_play,
        reactivation_flag = 'Y' as is_reactivation_target,
        high_worth_unhosted_flag = 'Y' as is_high_worth_unhosted,
        identity_resolved_from_sources

    from source

)

select * from final
