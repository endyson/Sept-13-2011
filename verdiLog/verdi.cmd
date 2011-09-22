srcSourceCodeView
srcResizeWindow 5 22 804 500
debImport "-f" "arm_core.f"
wvCreateWindow
wvResizeWindow -win $_nWave2 50 214 960 332
wvResizeWindow -win $_nWave2 55 236 960 332
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 \
           {/mnt/hgfs/Projects/local_repo/github/out/log/wavevform.fsdb}
srcDeselectAll -win $_nTrace1
srcSelect -signal "inst_valid_stage_2" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "inst_valid" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 2786.194211 -snap {("G1" 2)}
wvSetCursor -win $_nWave2 2957.945909
wvSetCursor -win $_nWave2 3320.532827
wvSetCursor -win $_nWave2 3072.447041
wvSetCursor -win $_nWave2 4064.790184
wvSetCursor -win $_nWave2 5133.467416
wvSetCursor -win $_nWave2 15134.187116
wvSetCursor -win $_nWave2 15134.187116
wvSetCursor -win $_nWave2 2938.862387
wvSetCursor -win $_nWave2 3778.537354
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -win $_nTrace1
srcAddSelectedToWave -win $_nTrace1
wvSetCursor -win $_nWave2 10400.519486 -snap {("G2" 0)}
wvResizeWindow -win $_nWave2 300 237 960 333
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
