# SAP-1

SAP-1 Implementation from the book [Digital Computer Electronics by Albert Malvino](https://www.amazon.com/Digital-Computer-Electronics-Albert-Malvino/dp/0028005945) and from [Brian Eater's 8-Bit Computer Video Series](https://www.youtube.com/watch?v=HyznrdDSSGM&list=PLowKtXNTBypGqImE405J2565dvjafglHU&index=1&ab_channel=BenEater)

## NOTES 
- testbenches in `test/` are mostly for visual checks at the moment. Not actually asserting pass/fails.
- instruction RAM is magic ram at the moment, contents immediately available when address changes.
- OPCODEs mirror Brian Eater's implementation and may not necessarily match the book. 

# TODO
- Change all active lows to active highs, for consistency 
- create a more reasonable `controller.v`
- implement halt opcode

# Schematic 

<img width="683" alt="image" src="https://user-images.githubusercontent.com/742516/221394647-07533ea6-8bb9-4f05-bef1-ca605313cdb2.png">
