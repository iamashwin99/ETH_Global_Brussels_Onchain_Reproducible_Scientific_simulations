#[starknet::interface]
pub trait Isimulate<TContractState> {
    fn simulate_ising(ref self: TContractState);
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
        pub A: ArrayTrait<bool>,
    }


    #[abi(embed_v0)]
    impl simulate of super::Isimulate<ContractState> {
        fn simulate_ising(ref self: ContractState) {
            let lb = 5;
            let mut i = 0;
            let num_iterations = 10;
            let rand_seed = 9987;
            let mut a = ArrayTrait::new();
            // Set all elements to 1
            loop {
                if i >= lb {
                    break;
                }
                a.append(false);
                i = i + 1;
            }

            // Run the main loop
            i=0;
            loop {
                if i >= num_iterations {
                    break;
                }
                i = i + 1;

                // choose the random cite
                let index = (i * rand_seed) % lb;

                // flip the bit and calculate deltaE
                let mut deltaE = if a[index] { 0 } else { 1 };  // should actually have been -1 and 1
                let deltaE = deltaE * 2;
                let deltaE = deltaE * (a[(index-1)%lb] + a[(index+1)%lb]);

                // There are more terms which we will ignore

                // flip the bit if deltaE is 0 or less than the temperature cutooff
                let temp_cutoff = 4;
                if deltaE <= temp_cutoff {
                    a[index] = !a[index];
                }

                // emmit the data
                self
                    .emit(
                        Event::PopulationUpdated(
                            PopulationUpdated { A: a }
                        )
                    );
            }

        }

    }
}

