#[starknet::interface]
pub trait Isimulate<TContractState> {
    fn simulate_ising(ref self: TContractState);
}

#[starknet::contract]
mod IsingSim {
    use dict::Felt252DictTrait;

    #[storage]
    struct Storage {}

    #[event]
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub enum Event {
        PopulationUpdated: PopulationUpdated,
    }

    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    struct PopulationUpdated {
        #[key]
        pub A: u32
    }


    #[abi(embed_v0)]
    impl simulate of super::Isimulate<ContractState> {
        fn simulate_ising(ref self: ContractState) {
            let lb: u32 = 5;
            let mut i: u32 = 0;
            let num_iterations: u32 = 10;
            let rand_seed: u32 = 9987;
            let mut a = felt252_dict_new::<bool>();
            // Set all elements to 1;
            loop {
                if i >= lb {
                    break;
                }
                a.insert(i.try_into().unwrap(), false);
                i = i + 1;
            };

            // Run the main loop
            i = 0;
            loop {
                if i >= num_iterations {
                    break;
                }
                i = i + 1;

                // choose the random cite
                let index: felt252 = ((i * rand_seed) % lb).try_into().unwrap();
                let index_int: u32 = index.try_into().unwrap();

                // flip the bit and calculate deltaE
                let mut deltaE = 1;
                // should actually have been -1
                if a[index.try_into().unwrap()] {
                    deltaE = 0;
                }
                deltaE = deltaE * 2;

                // 5 here is lb
                let left_index: felt252 = ((index_int - 1) % 5).try_into().unwrap();
                let right_index: felt252 = ((index_int + 1) % 5).try_into().unwrap();

                let mut E_left: u32 = 0;
                let mut E_right: u32 = 0;
                if a[left_index] {
                    E_left = 1;
                }
                if a[right_index] {
                    E_right = 1;
                }
                deltaE = deltaE * (E_left + E_right);
                // let deltaE = deltaE * (a[(index-1)%lb] + a[(index+1)%lb]);

                // There are more terms which we will ignore

                // flip the bit if deltaE is 0 or less than the temperature cutooff
                let temp_cutoff: u32 = 4;
                if deltaE <= temp_cutoff {
                    a.insert(index.try_into().unwrap(), !a[index]);
                }

                // Convert the new state into an integer
                let mut j: u32 = 0;
                let mut state = 0;
                let mut power = 1;
                loop {
                    if j > lb {
                        break;
                    }

                    j = j + 1;
                    power = power * 2;

                    if a[j.try_into().unwrap()] {
                        state = state + power;
                    }
                };

                // emmit the data
                self.emit(Event::PopulationUpdated(PopulationUpdated { A: state }));
            }
        }
    }
}

