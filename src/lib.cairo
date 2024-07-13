
#[starknet::contract]
mod Contract {

    #[storage]
    struct Storage {

    }
    #[external(v0)]
    fn returnFive(self: @ContractState) -> u256 {
        5
    }



}