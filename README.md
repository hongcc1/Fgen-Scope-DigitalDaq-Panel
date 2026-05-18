# FGEN - Scope - Digital DAQ Test Panel
## Overview
This Test Panel can control FGEN and DAQ to generate a sequence of analog and digital waveforms from a TDMS file. While generating, it can also control SCOPE to capture multiple records according to the number of steps and loops in the Waveform Sequence (FGEN or DAQ).

![Test Panel Multiple Loops](Images/Test%20Panel%20Multiple%20Loops.png)

## Software Requirement
- LabVIEW 2025 or later
- NI FGEN
- NI SCOPE
- NI DAQmx

## How It Works
### Basics
Usually when getting started, you may not have all the instruments settings ready. So, this Test Panel is designed to be flexible to work with different instrument combinations.

You can choose to disable FGEN, DAQ or SCOPE function by leaving thier Resource Names blank. 

If FGEN and DAQ are enabled, DAQ will arm the FGEN start trigger before it starts generation through the PXI backplane (or route through PFI). If only DAQ enabled, DAQ will start generation immediately.

Before start, prepare a TMDS waveform file that matches the TDMS Name Mapping:
![TDMS Name Mapping](Images/TDMS%20Name%20Mapping.png)

- For FGEN:
    - Refer to the FGEN Channel Mapping and FGEN Wfm List.
    - FGEN will run with the Arbitrary Sequence mode and Single Trigger mode to generate the waveforms in the FGEN Wfm Sequence. 
    - Data will be resampled to the highest sample rate among all the FGEN waveforms.
- For DAQ:
    - Refer to the DAQ Channel Mapping and DAQ Wfm List
    - The waveforms specified in the DAQ Wfm Sequence will be cascaded as one waveform for each channel. 
    - Data will be resampled to the highest sample rate among all the DAQ waveforms.

Then, configure the FGEN and DAQ Sequence accordingly. By default, each step only loops once. You can increase it. The number of records to be captured by SCOPE will be total number of loops. You must make sure the number of sequence steps and loops are equal. The code doesn't check the consistency.  
![Sequence Settings](Images/Sequence%20Settings.png)

Use the InstrumentStudio to configure the settings of SCOPE first, and export the settings as .niscopeconfig file. Then, you can use the file to configure the settings in this Test Panel.

You can get started quickly using the TDMS waveform provided in `Sample Waveforms\Sinc-Digitial-Generation1.tdms`.

### Conditional Disable Symbols in LabVIEW Project 
In the LabVIEW Project properties, it has the following Conditional Disable Symbols, which will be used by the [Conditional Disable Structure](https://www.ni.com/docs/en-US/bundle/labview-api-ref/page/structures/conditional-disable-structure.html) in the code:

![Conditional Disable Symbols](Images/Conditional%20Disable%20Symbols.png)

**DO_ONBOARD_CLK**
- Set this TRUE if DAQ has onboard clock as sample clock source for digital channel 
- Set this FALSE if want to use DAQ counter as sample clock source for digital channel

**MARKER0_EXPORT_PFI**
- When the DAQ is not a PXI module (such as USB or PCI), set this to TRUE to export FGEN marker0 event to FGEN PFI0 port. Then wire it physically to the DAQ PFI0 as start trigger source. This assumes DAQ onboard clock as sample clock source
- When the DAQ is a PXI module, set this to FALSE so that don't export FGEN marker0 event to FGEN PFI0 port.  

### Instruments Synchronization
For every step in a FGEN Waveform Sequence, a `Marker0` event is always configured at the first sample. This marker can be used to synchronize the start of DAQ Digital Output task (DO) and Scope capturing in the following ways: 
- DAQ Digital Output Task:
    - (Default) Route `Marker0` event to the start of DO Task
    ![Route Marker0 to DO](Images/Route%20Marker0%20to%20DO.png)

    - Route `Marker0` event to the start of counter0 task (for M-Series PXI DAQ that does not have onboard clock for DO task)
    ![Route Marker0 to Counter](Images/Route%20Marker0%20to%20Counter.png)

    - Route `Marker0` event to the FGEN PFI0 port, then physically wire to DAQ PFI0 channel to send start trigger the DO Task
    ![Route Marker0 to PFI](Images/Route%20Marker0%20to%20PFI.png)

- Scope capture:
    - In InstrumentStudio, configure the scope session to use the `Digital Edge` trigger, where the source is the FGEN `Marker0` event. For example: \Fgen5433\0\Marker0 (Fgen5433 is the instrument name), then export the settings into niscopeconfig file. That will ensure the starting point of capture is the `Marker0` event. You may adjust the `Trigger Delay` on the Test Panel to add delay after this. 

### Single Loop vs Multiple Loops Test Panel
In the project, you can find two different Test Panels: `Test Panel - Single Loop.vi` and `Test Panel - Multiple Loops.vi`. The former one only runs one loop for the whole sequence, while the latter one can run multiple loops of sequence. For the later, between the loops, it has a software-timed delay to allow device under test to settle down. This enables you to remove the long idle time waveforms from loading them into the FGEN and DAQ. You can adjust the delay time on the Test Panel. 

## Create Sample TDMS waveform file
As an example to get started quickly, you can use the `Sample Waveforms\Sinc-Digitial-Generation1.tdms` file. This TDMS waveform file is generated using the `Sinc generator to TDMS.vi` in the LabVIEW project. You can also modify the code to generate your own TDMS waveform file.

You must remember that the DAQ sample rate is far below than the FGEN sample rate. [Most of the NI DAQ X-series devices have maximum sample rate of 1MHz or 10MHz](https://www.ni.com/en/support/documentation/supplemental/09/what-is-ni-x-series-.html). Taking `Sinc generator to TDMS.vi` as an example, in the Digital Waveform Settings tab, you can choose to use the sample rate **Same Fs as RF Wfm** (FGEN) or **Resampled Fs** to resample digital waveform to specific sample rate as shown below:
![Digital Waveform Creation Settings](Images/Digital%20Waveform%20Creation%20Settings.png)

You can use the Express VI "Align and Resample" to resample the original digital waveform to the target sample rate for DAQ. See the example below:
![Align and Resample Example](Images/Align%20and%20Resample%20Example.png)

## Customize the Code for Your Application
### Automation Example
Refer to the (Code/Test Automatation Example1.vi)[Code/Test%20Automatation%20Example1.vi], which shows how to call the code in `Test Panel - Single Loop.vi` to automate the test which sweep different parameters (tdms file path), and then post-process the waveforms to decide whether should proceed to the next iteration. You can modify the code to fit your application.

![Automation Example](Images/Test%20Automation%20Example1.png)

### Waveform Post-Processing Example
Refer to the (Code\SubVI\Evaluate Captured Waveforms 2.vi)[Code/SubVI/Evaluate%20Captured%20Waveforms%202.vi] and (Code\Test Panel - Multiple Loops.vi)[Code/Test%20Panel%20-%20Multiple%20Loops.vi], which shows how to post-processing the waveforms by taking the RMS.

![Post-Processing Example](Images/Post%20Process%20Waveform%201.png)

The post-processing VI is called **Average Waveforms By RMS.vi**. This VI takes the original scope captured waveforms which are saved as `Live Graph Plotter.lvclass`, and then allow to specifying the Record indices and channel list to average by RMS. Following figure shows it takes all records (start = 0, length = -1) of channel 2 to calculate the RMS waveform of FFT (dB). You can modify the code to fit your application.

![Post-Processing Example on Test Panel - Multiple Loops](Images/Post%20Process%20Waveform%202.png)

This is how inside the code looks like: 

![Code inside Average Waveforms By RMS.vi](Images/Post%20Process%20Waveform%203.png)
