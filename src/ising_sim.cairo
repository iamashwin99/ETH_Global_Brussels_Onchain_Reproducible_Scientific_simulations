#[starknet::interface]
pub trait Isimulate<TContractState> {
    fn simulate_ising(ref self: TContractState);
}

#[starknet::contract]
mod IsingSim {
    use dict::Felt252DictTrait;

    #[storage]
    struct Storage {
    }

    #[event]
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        PopulationUpdated: PopulationUpdated,
    }

    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    struct PopulationUpdated {
        #[key]
        pub A: u32,
    }


    #[abi(embed_v0)]
    impl simulate of super::Isimulate<ContractState> {
        fn simulate_ising(ref self: ContractState) {
            let lb = 5;
            let mut i = 0;
            let num_iterations = 10;
            let rand_seed = 9987;
            let mut a = felt252_dict_new::<bool>();
            // Set all elements to 1;
            loop {
                if i >= lb {
                    break;
                }
                a.insert(i, false);
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
                let mut deltaE = 1;
                // should actually have been -1
                if a[index] {
                    deltaE = 0;
                    }
                let deltaE = deltaE * 2;
                let deltaE = deltaE * (a[(index-1)%lb] + a[(index+1)%lb]);

                // There are more terms which we will ignore

                // flip the bit if deltaE is 0 or less than the temperature cutooff
                let temp_cutoff = 4;
                if deltaE <= temp_cutoff {
                    a.insert(index, !a[index]);
                }

                // Convert the new state into an integer
                i = 0;
                let mut state = 0;
                let power = 1;
                loop {
                    if i>lb {
                        break;
                    }

                    i = i + 1;
                    power = power * 2;

                    if a[i] {
                        state = state + power;
                    }

                }


                // emmit the data
                self
                    .emit(
                        Event::PopulationUpdated(
                            PopulationUpdated { A: state }
                        )
                    );
            }

        }

    }
}

