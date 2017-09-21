#!/bin/bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2017, Reperio LLC
#

METRIC="$1"

if [[ -z "$1" ]]; then
    echo "Please specify a metric"
    exit 1
fi

KAMCTL=/usr/sbin/kamctl
CACHE="/tmp/kamailio-stats.cache"
CACHETTL="30"

if [ -s "$CACHE" ]; then
    TIMECACHE=`stat -c"%Z" "$CACHE"`
else
    TIMECACHE=0
fi

TIMENOW=`date '+%s'`

if [ "$(($TIMENOW - $TIMECACHE))" -gt "$CACHETTL" ]; then
    sudo $KAMCTL stats | jq . > $CACHE || exit 1

fi

KAMCMD=/usr/sbin/kamcmd
KAMCMD_CACHE="/tmp/kamcmd-stats.cache"
KAMCMD_CACHETTL="30"

if [ -s "$KAMCMD_CACHE" ]; then
    KAMCMD_TIMECACHE=`stat -c"%Z" "$KAMCMD_CACHE"`
else
    KAMCMD_TIMECACHE=0
fi

KAMCMD_TIMENOW=`date '+%s'`

if [ "$(($KAMCMD_TIMENOW - $KAMCMD_TIMECACHE))" -gt "$KAMCMD_CACHETTL" ]; then
    sudo $KAMCMD mod.stats all pkg | grep Total | tr -d "[:blank:]" | cut -d: -f2 | paste -sd+ -| bc > $KAMCMD_CACHE || exit 1
fi


case $METRIC in
    'core-bad_URIs_rcvd')        cat $CACHE | grep 'core:bad_URIs_rcvd' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-bad_msg_hdr')          cat $CACHE | grep 'core:bad_msg_hdr' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-drop_replies')         cat $CACHE | grep 'core:drop_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-drop_requests')        cat $CACHE | grep 'core:drop_requests' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-err_replies')          cat $CACHE | grep 'core:err_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-err_requests')         cat $CACHE | grep 'core:err_requests' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-fwd_replies')          cat $CACHE | grep 'core:fwd_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-fwd_requests')         cat $CACHE | grep 'core:fwd_requests' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_replies')          cat $CACHE | grep 'core:rcv_replies ' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_replies_18x')      cat $CACHE | grep 'core:rcv_replies_18x' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_replies_1xx')      cat $CACHE | grep 'core:rcv_replies_1xx' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_replies_2xx')      cat $CACHE | grep 'core:rcv_replies_2xx' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_replies_3xx')      cat $CACHE | grep 'core:rcv_replies_3xx' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_replies_401')      cat $CACHE | grep 'core:rcv_replies_401' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_replies_404')      cat $CACHE | grep 'core:rcv_replies_404' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_replies_407')      cat $CACHE | grep 'core:rcv_replies_407' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_replies_480')      cat $CACHE | grep 'core:rcv_replies_480' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_replies_486')      cat $CACHE | grep 'core:rcv_replies_486' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_replies_4xx')      cat $CACHE | grep 'core:rcv_replies_4xx' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_replies_5xx')      cat $CACHE | grep 'core:rcv_replies_5xx' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_replies_6xx')      cat $CACHE | grep 'core:rcv_replies_6xx' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests')         cat $CACHE | grep 'core:rcv_requests ' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_ack')     cat $CACHE | grep 'core:rcv_requests_ack' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_bye')     cat $CACHE | grep 'core:rcv_requests_bye' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_cancel')  cat $CACHE | grep 'core:rcv_requests_cancel' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_info')    cat $CACHE | grep 'core:rcv_requests_info' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_invite')  cat $CACHE | grep 'core:rcv_requests_invite' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_message') cat $CACHE | grep 'core:rcv_requests_message' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_notify')  cat $CACHE | grep 'core:rcv_requests_notify' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_options') cat $CACHE | grep 'core:rcv_requests_options' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_prack')   cat $CACHE | grep 'core:rcv_requests_prack' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_publish') cat $CACHE | grep 'core:rcv_requests_publish' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_refer')   cat $CACHE | grep 'core:rcv_requests_refer' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_register') cat $CACHE | grep 'core:rcv_requests_register' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_subscribe') cat $CACHE | grep 'core:rcv_requests_subscribe' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-rcv_requests_update')  cat $CACHE | grep 'core:rcv_requests_update' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'core-unsupported_methods')  cat $CACHE | grep 'core:unsupported_methods' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'dns-failed_dns_request')    cat $CACHE | grep 'dns:failed_dns_request' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'nat_traversal-dialog_endpoints')    cat $CACHE | grep 'nat_traversal:dialog_endpoints' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'nat_traversal-keepalive_endpoints')    cat $CACHE | grep 'nat_traversal:keepalive_endpoints' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'nat_traversal-registered_endpoints')    cat $CACHE | grep 'nat_traversal:registered_endpoints' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'nat_traversal-subscribed_endpoints')    cat $CACHE | grep 'nat_traversal:subscribed_endpoints' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'registrar-accepted_regs')   cat $CACHE | grep 'registrar:accepted_regs' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'registrar-default_expire')  cat $CACHE | grep 'registrar:default_expire ' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'registrar-default_expires_range') cat $CACHE | grep 'registrar:default_expires_range' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'registrar-max_contacts')    cat $CACHE | grep 'registrar:max_contacts' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'registrar-max_expires')     cat $CACHE | grep 'registrar:max_expires' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'registrar-rejected_regs')   cat $CACHE | grep 'registrar:rejected_regs' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'shmem-fragments')           cat $CACHE | grep 'shmem:fragments' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'shmem-free_size')           cat $CACHE | grep 'shmem:free_size' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'shmem-max_used_size')       cat $CACHE | grep 'shmem:max_used_size' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'shmem-real_used_size')      cat $CACHE | grep 'shmem:real_used_size' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'shmem-total_size')          cat $CACHE | grep 'shmem:total_size' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'shmem-used_size')           cat $CACHE | grep 'shmem:used_size' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-1xx_replies')            cat $CACHE | grep 'sl:1xx_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-200_replies')            cat $CACHE | grep 'sl:200_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-202_replies')            cat $CACHE | grep 'sl:202_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-2xx_replies')            cat $CACHE | grep 'sl:2xx_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-300_replies')            cat $CACHE | grep 'sl:300_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-301_replies')            cat $CACHE | grep 'sl:301_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-302_replies')            cat $CACHE | grep 'sl:302_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-3xx_replies')            cat $CACHE | grep 'sl:3xx_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-400_replies')            cat $CACHE | grep 'sl:400_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-401_replies')            cat $CACHE | grep 'sl:401_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-403_replies')            cat $CACHE | grep 'sl:403_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-404_replies')            cat $CACHE | grep 'sl:404_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-407_replies')            cat $CACHE | grep 'sl:407_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-408_replies')            cat $CACHE | grep 'sl:408_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-483_replies')            cat $CACHE | grep 'sl:483_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-4xx_replies')            cat $CACHE | grep 'sl:4xx_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-500_replies')            cat $CACHE | grep 'sl:500_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-5xx_replies')            cat $CACHE | grep 'sl:5xx_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-6xx_replies')            cat $CACHE | grep 'sl:6xx_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-failures')               cat $CACHE | grep 'sl:failures' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-received_ACKs')          cat $CACHE | grep 'sl:received_ACKs' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-sent_err_replies')       cat $CACHE | grep 'sl:sent_err_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-sent_replies')           cat $CACHE | grep 'sl:sent_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'sl-xxx_replies')            cat $CACHE | grep 'sl:xxx_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tcp-con_reset')             cat $CACHE | grep 'tcp:con_reset' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tcp-con_timeout')           cat $CACHE | grep 'tcp:con_timeout' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tcp-connect_failed')        cat $CACHE | grep 'tcp:connect_failed' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tcp-connect_success')       cat $CACHE | grep 'tcp:connect_success' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tcp-current_opened_connections') cat $CACHE | grep 'tcp:current_opened_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tcp-current_write_queue_size')   cat $CACHE | grep 'tcp:current_write_queue_size' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tcp-established')           cat $CACHE | grep 'tcp:established' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tcp-local_reject')          cat $CACHE | grep 'tcp:local_reject' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tcp-passive_open')          cat $CACHE | grep 'tcp:passive_open' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tcp-send_timeout')          cat $CACHE | grep 'tcp:send_timeout' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tcp-sendq_full')            cat $CACHE | grep 'tcp:sendq_full' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-2xx_transactions')      cat $CACHE | grep 'tmx:2xx_transactions' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-3xx_transactions')      cat $CACHE | grep 'tmx:3xx_transactions' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-4xx_transactions')      cat $CACHE | grep 'tmx:4xx_transactions' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-5xx_transactions')      cat $CACHE | grep 'tmx:5xx_transactions' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-6xx_transactions')      cat $CACHE | grep 'tmx:6xx_transactions' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-UAC_transactions')      cat $CACHE | grep 'tmx:UAC_transactions' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-UAS_transactions')      cat $CACHE | grep 'tmx:UAS_transactions' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-active_transactions')   cat $CACHE | grep 'tmx:active_transactions' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-inuse_transactions')    cat $CACHE | grep 'tmx:inuse_transactions' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-local_replies')         cat $CACHE | grep 'tmx:local_replies' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-rpl_absorbed')         cat $CACHE | grep 'tmx:rpl_absorbed' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-rpl_generated')         cat $CACHE | grep 'tmx:rpl_generated' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-rpl_received')         cat $CACHE | grep 'tmx:rpl_received' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-rpl_relayed')         cat $CACHE | grep 'tmx:rpl_relayed' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'tmx-rpl_sent')         cat $CACHE | grep 'tmx:rpl_sent' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'usrloc-location-contacts')  cat $CACHE | grep 'usrloc:location-contacts' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'usrloc-location-expires')   cat $CACHE | grep 'usrloc:location-expires' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'usrloc-location-users')     cat $CACHE | grep 'usrloc:location-users' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'usrloc-registered_users')   cat $CACHE | grep 'usrloc:registered_users' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_current_connections')   cat $CACHE | grep 'websocket:ws_current_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_failed_connections')   cat $CACHE | grep 'websocket:ws_failed_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_failed_handshakes')   cat $CACHE | grep 'websocket:ws_failed_handshakes' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_local_closed_connections')   cat $CACHE | grep 'websocket:ws_local_closed_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_max_concurrent_connections')   cat $CACHE | grep 'websocket:ws_max_concurrent_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_msrp_current_connections')   cat $CACHE | grep 'websocket:ws_msrp_current_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_msrp_failed_connections')   cat $CACHE | grep 'websocket:ws_msrp_failed_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_msrp_local_closed_connections')   cat $CACHE | grep 'websocket:ws_msrp_local_closed_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_msrp_max_concurrent_connections')   cat $CACHE | grep 'websocket:ws_msrp_max_concurrent_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_msrp_received_frames')   cat $CACHE | grep 'websocket:ws_msrp_received_frames' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_msrp_remote_closed_connections')   cat $CACHE | grep 'websocket:ws_msrp_remote_closed_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_msrp_successful_handshakes')   cat $CACHE | grep 'websocket:ws_msrp_successful_handshakes' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_msrp_transmitted_frames')   cat $CACHE | grep 'websocket:ws_msrp_transmitted_frames' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_received_frames')   cat $CACHE | grep 'websocket:ws_received_frames' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_remote_closed_connections')   cat $CACHE | grep 'websocket:ws_remote_closed_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_sip_current_connections')   cat $CACHE | grep 'websocket:ws_sip_current_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_sip_failed_connections')   cat $CACHE | grep 'websocket:ws_sip_failed_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_sip_local_closed_connections')   cat $CACHE | grep 'websocket:ws_sip_local_closed_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_sip_max_concurrent_connections')   cat $CACHE | grep 'websocket:ws_sip_max_concurrent_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_sip_received_frames')   cat $CACHE | grep 'websocket:ws_sip_received_frames' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_sip_remote_closed_connections')   cat $CACHE | grep 'websocket:ws_sip_remote_closed_connections' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_sip_successful_handshakes')   cat $CACHE | grep 'websocket:ws_sip_successful_handshakes' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_sip_transmitted_frames')   cat $CACHE | grep 'websocket:ws_sip_transmitted_frames' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_successful_handshakes')   cat $CACHE | grep 'websocket:ws_successful_handshakes' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'websocket-ws_transmitted_frames')   cat $CACHE | grep 'websocket:ws_transmitted_frames' | tr -d "[:blank:]" |cut -d'=' -f2 | tr -d "[:punct:]" ;;
    'pkg-mem_used') cat $KAMCMD_CACHE ;;
    *)  echo "Not selected metric"
        exit 0
        ;;
esac
