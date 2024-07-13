#[starknet::interface]
pub trait Isimulate<TContractState> {
    fn simulate_growth(ref self: TContractState, value: u128);
}

#[starknet::contract]
mod PopulationGrowth {
    #[storage]
    struct Storage {
        population: u128,
    }


    #[abi(embed_v0)]
    impl simulate of super::Isimulate<ContractState> {
        fn simulate_growth(ref self: ContractState, population:u128, growth_rate: u128) {
            let mut i: usize = 0;
            loop {
                if i > 10 {
                    break;
                    let growth = self.population.read() * growth_rate;
                    self.population.write(self.population.read() + growth );
                    println!("For the year {}: Population = {}", i, self.population.read());
                }
            }
        }
    }
}
