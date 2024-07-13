#[starknet::interface]
pub trait Isimulate<TContractState> {
    fn simulate_ising(ref self: TContractState, population: u128, growth_rate: u128);
}

#[starknet::contract]
mod IsingSim {
    use core::array::ArrayTrait;

    #[storage]
    struct Storage {
        population: u128,
    }
    #[event]
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        PopulationUpdated: PopulationUpdated,
    }

    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    struct PopulationUpdated {
        #[key]
        pub Year: u32,
        #[key]
        pub Population: u128,
    }


    #[abi(embed_v0)]
    impl simulate of super::Isimulate<ContractState> {
        fn simulate_ising(ref self: ContractState, population: u128, growth_rate: u128) {
            let mut arr = ArrayTrait::<u128>::new();

        }
    }
}

