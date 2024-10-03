import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SimpleLudoModule = buildModule("SimpleLudoModule", (m) => {

    const ludo = m.contract("SimpleLudo");

    return { ludo };
});

export default SimpleLudoModule;
