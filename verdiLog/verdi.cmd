srcSourceCodeView
srcResizeWindow 75 53 1111 500
debImport "-f" "arm_core.f"
wvCreateWindow
wvResizeWindow -win $_nWave2 151 274 960 332
wvResizeWindow -win $_nWave2 156 296 960 332
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 \
           {/mnt/hgfs/Projects/local_repo/github/out/log/wavevform.fsdb}
srcDeselectAll -win $_nTrace1
srcHBSelect "tb_arm_core.u_arm_core" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_arm_core.u_arm_core" -delim "."
srcHBSelect "tb_arm_core.u_arm_core.u_xpsr_reg" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_arm_core.u_arm_core.u_xpsr_reg" -delim "."
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "en_apsr" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "en_ipsr" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "en_epsr" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
wvSelectGroup -win $_nWave2 {G2}
wvResizeWindow -win $_nWave2 -4 0 1366 721
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 349722.185109 -snap {("G1" 3)}
wvSetCursor -win $_nWave2 352913.913004 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 352706.657946
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvSelectSignal -win $_nWave2 {( "G1" 1 )} 
wvSetPosition -win $_nWave2 {("G1" 1)}
wvExpandBus -win $_nWave2 {("G1" 1)}
wvSetPosition -win $_nWave2 {("G1" 8)}
wvSetCursor -win $_nWave2 352996.815027
wvSetCursor -win $_nWave2 350758.460399 -snap {("G2" 0)}
wvSelectSignal -win $_nWave2 {( "G1" 4 )} 
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvSelectSignal -win $_nWave2 {( "G1" 2 )} 
srcDeselectAll -win $_nTrace1
debExit
