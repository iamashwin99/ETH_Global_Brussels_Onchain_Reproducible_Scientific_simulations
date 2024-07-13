#[starknet::interface]
pub trait Isimulate<TContractState> {
    fn simulate_growth(ref self: TContractState, population: u128, growth_rate: u128);
}

#[starknet::contract]
mod PopulationGrowth {
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
        pub Population: u128,
    }


    #[abi(embed_v0)]
    impl simulate of super::Isimulate<ContractState> {
        fn simulate_growth(ref self: ContractState, population: u128, growth_rate: u128) {
            let mut i: u32 = 0;
            loop {
                if i > 10 {
                    break;
                }
                i = i + 1;
                let growth = self.population.read() * (1 + growth_rate) / 100;
                self.population.write(self.population.read() + growth);
                self
                    .emit(
                        Event::PopulationUpdated(
                            PopulationUpdated { Year: i, Population: self.population.read() }
                        )
                    );
            }
        }
    }
}

