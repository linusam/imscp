<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>{TR_CLIENT_ADD_ALIAS_PAGE_TITLE}</title>
	<meta http-equiv='Content-Script-Type' content='text/javascript' />
	<meta http-equiv='Content-Style-Type' content='text/css' />
	<meta http-equiv='Content-Type' content='text/html; charset={THEME_CHARSET}' />
	<meta name='copyright' content='i-MSCP' />
	<meta name='owner' content='i-MSCP' />
	<meta name='publisher' content='i-MSCP' />
	<meta name='robots' content='nofollow, noindex' />
	<meta name='title' content='{TR_CLIENT_ADD_ALIAS_PAGE_TITLE}' />
	<link href="{THEME_COLOR_PATH}/css/imscp.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="{THEME_COLOR_PATH}/js/imscp.js"></script>
	<script type="text/javascript" src="{THEME_COLOR_PATH}/js/jquery.js"></script>
	<script type="text/javascript" src="{THEME_COLOR_PATH}/js/jquery.imscpTooltips.js"></script>
	<!--[if IE 6]>
		<script type="text/javascript" src="{THEME_COLOR_PATH}/js/DD_belatedPNG_0.0.8a-min.js"></script>
		<script type="text/javascript">
			DD_belatedPNG.fix('*');
		</script>
	<![endif]-->
	<script type="text/javascript">
	/* <![CDATA[ */
		$(document).ready(function(){
			// Tooltips - begin
			$('#dmn_help').iMSCPtooltips({msg:"{TR_DMN_HELP}"})
			// Tooltips - end

			// Request for encode_idna request
			$('input[name=ndomain_name]').blur(function(){
				dmnName = $('#ndomain_name').val();
				// Configure the request for encode_idna request
				$.ajaxSetup({
				url: $(location).attr('pathname'),
					type:'POST',
					data: 'domain=' + dmnName + '&uaction=toASCII',
					datatype: 'text',
					beforeSend: function(xhr){xhr.setRequestHeader('Accept','text/plain');},
					success: function(r){$('#ndomain_mpoint').val(r);},
					error: iMSCPajxError
				});
				$.ajax();
			});
		});

		function setForwardReadonly(obj){
			if(obj.value == 1) {
				document.forms[0].elements['forward'].readOnly = false;
				document.forms[0].elements['forward_prefix'].disabled = false;
			} else {
				document.forms[0].elements['forward'].readOnly = true;
				document.forms[0].elements['forward'].value = '';
				document.forms[0].elements['forward_prefix'].disabled = true;
			}
		}
	/* ]]> */
	</script>
</head>
<body>
	<div class="header">
		{MAIN_MENU}
		<div class="logo">
			<img src="{ISP_LOGO}" alt="i-MSCP logo" />
		</div>
	</div>
	<div class="location">
		<div class="location-area icons-left">
			<h1 class="domains">{TR_MENU_MANAGE_DOMAINS}</h1>
		</div>
		<ul class="location-menu">
			<!-- <li><a class="help" href="#">Help</a></li> -->
			<!-- BDP: logged_from -->
			<li><a class="backadmin" href="change_user_interface.php?action=go_back">{YOU_ARE_LOGGED_AS}</a></li>
			<!-- EDP: logged_from -->
			<li><a class="logout" href="../index.php?logout">{TR_MENU_LOGOUT}</a></li>
		</ul>
		<ul class="path">
			<li><a href="domains_manage.php">{TR_MENU_MANAGE_DOMAINS}</a></li>
			<li><a href="alias_add.php">{TR_MENU_ADD_ALIAS}</a></li>
		</ul>
	</div>
	<div class="left_menu">{MENU}</div>
	<div class="body">
		<!-- BDP: page_message -->
			<div class="{MESSAGE_CLS}">{MESSAGE}</div>
		<!-- EDP: page_message -->
		<h2 class="domains"><span>{TR_MANAGE_DOMAIN_ALIAS}</span></h2>
		<form name="add_alias_frm" method="post" action="alias_add.php">
			<fieldset>
				<legend>{TR_ADD_ALIAS}</legend>
				<table>
					<tr>
						<td style="width: 300px;">
							 <label for="ndomain_name">{TR_DOMAIN_NAME}</label><span class="icon i_help" id="dmn_help">Help</span>
						</td>
						<td>
							<div style="text-align:right;">http://</div>
						</td>
						<td>
							<input name="ndomain_name" id="ndomain_name" type="text" value="{DOMAIN}" />
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<label for="ndomain_mpoint">{TR_MOUNT_POINT}</label>
						</td>
						<td>
							<input name="ndomain_mpoint" type="text" id="ndomain_mpoint" value="{MP}" />
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<label for="status">{TR_ENABLE_FWD}</label>
						</td>
						<td>
							<input type="radio" name="status" id="status_enable"{CHECK_EN} value="1" onChange="setForwardReadonly(this);" /><label for="status_enable">{TR_ENABLE}</label><br />
							<input type="radio" name="status" id="status_disable"{CHECK_DIS} value="0" onChange="setForwardReadonly(this);" /><label for="status_disable">{TR_DISABLE}</label>
						</td>
					</tr>
					<tr>
                        <td colspan="2">
                        	<label for="status">{TR_FORWARD}</label>
	                        </td>
							<td>
								<select name="forward_prefix" style="vertical-align:middle"{DISABLE_FORWARD}>
									<option value="{TR_PREFIX_HTTP}"{HTTP_YES}>{TR_PREFIX_HTTP}</option>
									<option value="{TR_PREFIX_HTTPS}"{HTTPS_YES}>{TR_PREFIX_HTTPS}</option>
									<option value="{TR_PREFIX_FTP}"{FTP_YES}>{TR_PREFIX_FTP}</option>
								</select>
							<input name="forward" type="text" class="textinput" id="forward" value="{FORWARD}"{READONLY_FORWARD} />
						</td>
					</tr>
				</table>
			</fieldset>
			<div class="buttons">
				<input type="hidden" name="uaction" value="add_alias" />
				<input type="submit" name="Submit" value="{TR_ADD}" />
			</div>
		</form>
	</div>
<!-- INCLUDE "footer.tpl" -->