//
//  RWLockCache.swift
//  PerfectLib
//
//  Created by Kyle Jessup on 2015-12-01.
//  Copyright © 2015 PerfectlySoft. All rights reserved.
//
//	This program is free software: you can redistribute it and/or modify
//	it under the terms of the GNU Affero General Public License as
//	published by the Free Software Foundation, either version 3 of the
//	License, or (at your option) any later version, as supplemented by the
//	Perfect Additional Terms.
//
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU Affero General Public License, as supplemented by the
//	Perfect Additional Terms, for more details.
//
//	You should have received a copy of the GNU Affero General Public License
//	and the Perfect Additional Terms that immediately follow the terms and
//	conditions of the GNU Affero General Public License along with this
//	program. If not, see <http://www.perfect.org/AGPL_3_0_With_Perfect_Additional_Terms.txt>.
//

import Foundation

/// This class implements a multi-reader single-writer thread-safe dictionary.
/// It provides a means for:
///	1. Fetching a value given a key, with concurrent readers
/// 2. Setting the value for a key with one writer while all readers block
/// 3. Fetching a value for a key with a callback, which, if the key does NOT exist, will be called to generate the new value in a thread-safe manner.
/// 4. Fetching a value for a key with a callback, which, if the key DOES exist, will be called to validate the value. If the value does nto validate then it will be removed from the dictionary in a thread-safe manner.
/// 5. Iterating all key/value pairs in a thread-safe manner while the write lock is held.
/// 6. Retrieving all keys while the read lock is held.
/// 7. Executing arbitrary blocks while either the read or write lock is held.
///
/// Note that if the validator callback indicates that the value is not valid, it will be called a second time while the write lock is held to ensure that the value has not been re-validated by another thread.
public class RWLockCache<KeyT: Hashable, ValueT> {
	
	public typealias KeyType = KeyT
	public typealias ValueType = ValueT
	
	public typealias ValueGenerator = () -> ValueType?
	public typealias ValueValidator = (value: ValueType) -> Bool
	
	private let queue = dispatch_queue_create("RWLockCache", DISPATCH_QUEUE_CONCURRENT)
	private var cache = [KeyType : ValueType]()
	
	public func valueForKey(key: KeyType) -> ValueType? {
		var value: ValueType?
		dispatch_sync(self.queue) {
			value = self.cache[key]
		}
		return value
	}
	
	public func valueForKey(key: KeyType, missCallback: ValueGenerator, validatorCallback: ValueValidator) -> ValueType? {
		var value: ValueType?
		
		dispatch_sync(self.queue) {
			value = self.cache[key]
		}
		
		if value == nil {
			dispatch_barrier_sync(self.queue) {
				value = self.cache[key]
				if value == nil {
					value = missCallback()
					if value != nil {
						self.cache[key] = value
					}
				}
			}
		} else if !validatorCallback(value: value!) {
			dispatch_barrier_sync(self.queue) {
				value = self.cache[key]
				if value != nil && !validatorCallback(value: value!) {
					self.cache.removeValueForKey(key)
					value = nil
				}
			}
		}
		return value
	}
	
	public func valueForKey(key: KeyType, validatorCallback: ValueValidator) -> ValueType? {
		var value: ValueType?
		
		dispatch_sync(self.queue) {
			value = self.cache[key]
		}
		
		if value != nil && !validatorCallback(value: value!) {
			dispatch_barrier_sync(self.queue) {
				value = self.cache[key]
				if value != nil && !validatorCallback(value: value!) {
					self.cache.removeValueForKey(key)
					value = nil
				}
			}
		}
		return value
	}
	
	public func valueForKey(key: KeyType, missCallback: ValueGenerator) -> ValueType? {
		var value: ValueType?
		
		dispatch_sync(self.queue) {
			value = self.cache[key]
		}
		
		if value == nil {
			dispatch_barrier_sync(self.queue) {
				value = self.cache[key]
				if value == nil {
					value = missCallback()
					if value != nil {
						self.cache[key] = value
					}
				}
			}
		}
		return value
	}
	
	public func setValueForKey(key: KeyType, value: ValueType) {
		dispatch_barrier_async(self.queue) {
			self.cache[key] = value
		}
	}
	
	public func keys() -> [KeyType] {
		var keys = [KeyType]()
		dispatch_sync(self.queue) {
			for key in self.cache.keys {
				keys.append(key)
			}
		}
		return keys
	}
	
	public func keysAndValues(callback: (KeyType, ValueType) -> ()) {
		dispatch_barrier_sync(self.queue) {
			for (key, value) in self.cache {
				callback(key, value)
			}
		}
	}
	
	public func withReadLock(callback: () -> ()) {
		dispatch_sync(self.queue) {
			callback()
		}
	}
	
	public func withWriteLock(callback: () -> ()) {
		dispatch_barrier_sync(self.queue) {
			callback()
		}
	}
}






