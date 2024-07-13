#[starknet::contract]
mod PopulationGrowth {

    #[storage]
    struct Storage {
        population: u128,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_population: u128) {
        self.population = initial_population

    }

    fn simulate_growth(growth_rate: felt252) {
        let mut i: usize = 0;
        loop {
            if i > 10 {
                break;
            let growth = self.population * growth_rate;
            self.population = self.population + growth;
            println!("For the year {}: Population = {}",i, self.population);
        }
    }
}
}