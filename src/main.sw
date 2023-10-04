contract;
use std::hash::*;
use std::storage::storage_vec::*;

storage{
    v: StorageMap<Address, StorageVec<u64>> = StorageMap {},
}

abi MyContract {
    #[storage(read, write)]
    fn test_function(n: u64);
}

impl MyContract for Contract {
    #[storage(read, write)]
    fn test_function(n: u64) {
        let address = msg_sender_address();
        let mut v = storage.v.get(address).try_read().unwrap_or(StorageVec{});
        v.push(n);
        storage.v.insert(address, v);
    }
}


pub fn msg_sender_address() -> Address {
    match std::auth::msg_sender().unwrap() {
        Identity::Address(identity) => identity,
        _ => revert(0),
    }
}