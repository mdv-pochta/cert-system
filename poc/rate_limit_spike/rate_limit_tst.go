// Package main contains spikes and proof-of-concepts for Certbot automation.
package main

import (
	"fmt"
)

func main() {
	fmt.Println("=== Rate Limiting Algorithm Spike ===")

	// Week limit from Let's Encrypt
	weekLimit := 50
	//renewalPriority := float64(0.6) // Renewals get priority
	newCertLimit := float64(0.75)  // New certs get max 75%
	parallelLimit := float64(0.50) // Max 50% parallel

	fmt.Printf("Let's Encrypt Weekly Limit: %d\n\n", weekLimit)

	// Scenario 1: Renewal wave
	renewals := 20
	newRequests := 100

	parallelSlots := int(float64(weekLimit) * parallelLimit)
	maxNewCerts := int(float64(weekLimit) * newCertLimit)

	fmt.Println("Scenario: Renewal wave with high new requests")
	fmt.Printf("  Renewals: %d\n", renewals)
	fmt.Printf("  New requests: %d\n\n", newRequests)

	// Renewals get priority
	renewalsProcessed := intMin(renewals, weekLimit)
	parallelRenewals := intMin(renewalsProcessed, parallelSlots)

	// New certs get remainder
	newAvailable := intMin(maxNewCerts, weekLimit-renewalsProcessed)

	fmt.Printf("Processing:\n")
	fmt.Printf("  Renewals processed: %d (all in queue)\n", renewalsProcessed)
	fmt.Printf("  Parallel renewals: %d\n", parallelRenewals)
	fmt.Printf("  New certs allowed: %d\n", newAvailable)
	fmt.Printf("  Queued for next week: %d\n", newRequests-newAvailable)
	fmt.Printf("  Total used: %d/%d\n", renewalsProcessed+newAvailable, weekLimit)
}

func intMin(a, b int) int {
	if a < b {
		return a
	}
	return b
}
